export const setMarkerColor = (
  markerId: number,
  colorHex: string
) => {
  const markerBoundary = document.getElementById(`markerBoundary${markerId}`);
  markerBoundary?.setAttribute('color', colorHex);
};

