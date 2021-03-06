% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/messages.R
\name{a_event}
\alias{a_event}
\title{a_event}
\usage{
a_event(id, event_name, event_detail = "", bubbles = FALSE)
}
\arguments{
\item{id}{the id of the entity that will have the event emitted on it.}

\item{event_name}{the name of the event.}

\item{event_detail}{data associated with the event.}

\item{bubbles}{TRUE if the event should bubble up to parents of the entity with `id`?}
}
\value{
An object that represents an A-Frame event.
}
\description{
Build an A-Frame Event Message
}
\details{
Construct an A-Frame event to be sent to a scene in browser, using a
websocket connection. When the event is received by a scene with an active
websocket server, it will be routed to the entity specified by `id`. To
handle the event the entity needs to have components that attach appropriate
event handlers.
}
