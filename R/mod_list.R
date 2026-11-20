#' List Server Module (listviewerlite)
#'
#' The client side is `js/src/components/ListTab.tsx`.
#'
#' @param id Module ID
#' @param data A reactive expression returning the dataset list
#'
#' @export
#'
mod_list_server <- function(id, data) {
  moduleServer(id, function(input, output, session) {
    logr_msg(
      message = "Initializing list server module",
      level = "DEBUG"
      )
    output$list <- renderUI({
      req(data())
      listviewerlite::listview(data())
    })
  })
}
