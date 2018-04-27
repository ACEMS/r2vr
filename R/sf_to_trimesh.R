sf_to_trimesh <- function(a_mulitpoly_sf, n_tris = NULL){
  
  if(!is(a_mulitpoly_sf, "sfc_MULTIPOLYGON")){
    stop("sf_to_tri_mesh can only work with sf geometry containing a single MULTIPOLYGON") 
  } 
  if(length(a_mulitpoly_sf) != 1){
    stop("Argument geomerty contained more than 1 MULTIPOLYGON. Use st_union() or st_combine()") 
  }

    # For RTRiangle we need:
    # P - A list of all unique vertices
    # PB - A vector the same length as P indicating if vertex is on boundary
    # PA - not required but maybe be useful for rastersation. Probably want explicit control.
    # S - a list of segments need boundary segments and hole segments
    #     Uses verex indicie in P.
    # SB - a vector the same length as S indicating boundaries
    # H - a vector of holes points in segments # For RTRiangle we need:
    # P - A list of all unique vertices
    # PB - A vector the same length as P indicating if vertex is on boundary
    # PA - not required but maybe be useful for rastersation. Probably want explicit control.
    # S - a list of segments need boundary segments and hole segments
    #     Uses verex indicie in P.
    # SB - a vector the same length as S indicating boundaries
    # H - a vector of holes points in segments

  island_list <-
    map(a_mulitpoly_sf[[1]], ~.[1]) %>% 
    flatten() %>%
    map(as_tibble) %>%
    map(~mutate(., type = "island"))
  
  hole_list <-
    map(a_mulitpoly_sf[[1]], ~.[-1]) %>%
    flatten() %>%
    map(as_tibble) %>%
    map(~mutate(., type = "hole"))
  
  all_polys_list <- c(island_list, hole_list)
  all_polys_list <-
    pmap(list(all_polys_list, seq_along(all_polys_list)),
      function(polygon_df, group_id){
        mutate(polygon_df, group = group_id)
      }
    )

  vertex_df <- 
    bind_rows(all_polys_list) %>%
    rename(x = V1, y = V2)
  
  unique_vertices <- 
    vertex_df %>%
    select(x, y) %>%
    unique() %>%
    mutate(id = seq_along(x))
  
  # Df containing P, PB, S, SB, where PB = SB
  segment_boundary_df <- 
    left_join(vertex_df, unique_vertices, by = c("x","y")) %>%
    group_by(group) %>%
    mutate(segment_start = id,
           segment_end = lead(id),
           boundary_ind = if_else(type == "island", 1, 0)) %>%
    ungroup()
  
  # Have NAs in segments, fine but before we drop those we need the closed 
  # vertex rings in x,y to calculate some centroids. 
  hole_centroids <-
    segment_boundary_df %>%
    filter(type == "hole") %>%
    group_by(group) %>%
    summarise(centroid = list( 
      st_centroid(st_polygon( list( as.matrix(cbind(x,y)) ) )) )) %>%
    pull(centroid) %>%
    map(as.matrix) %>%
    do.call(rbind, .)

  # Drop segments that contain NAs
  segment_boundary_df <- drop_na(segment_boundary_df)

  vertex_boundary_df <-
    segment_boundary_df %>%
    select(x,y,boundary_ind) %>%
    unique()  

  rtri_args <- 
    list(
      P = vertex_boundary_df %>%
         select(x, y) %>%
         as.matrix(),   
      PB = pull(vertex_boundary_df, boundary_ind),
      S = segment_boundary_df %>%
          select(segment_start, segment_end) %>%
          as.matrix(),
      SB = pull(segment_boundary_df, boundary_ind),
      H = if(is.null(hole_centroids)) NA else hole_centroids
      )
  
  # Calculate the triangle area to give approx n_tris
  if (!is.null(n_tris)){
    bbox <- st_bbox(a_mulitpoly_sf)
    area <- (bbox[3] - bbox[1]) * (bbox[4] - bbox[2])
    tri_area <- area/n_tris
  } else {
    tri_area <- NULL
  }


  rt_pslg <- do.call(RTriangle::pslg, rtri_args)
  
  rt_triangles <- RTriangle::triangulate(rt_pslg, a = tri_area)
}
