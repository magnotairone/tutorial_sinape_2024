library(shiny)
library(shinyChatR)
library(shinyjs)  # Inclui o shinyjs para manipulação de elementos no UI
library(shinythemes) 
library(reticulate)

reticulate::use_virtualenv("langchain_rag")

reticulate::py_run_file("chat.py")

obter_resposta_chat <- function(pergunta, id_sessao = "abc123"){
  resultado = py$obter_resposta(pergunta, id_sessao)
  return(resultado$answer)
}

csv_path <- "chat.csv"
id_chat <- as.character(round(runif(1, 1000000000000, 9999999999999)))
id_sendMessageButton <- paste0(id_chat, "-chatFromSend")
chat_user <- "Você"
bot <- "ggplotGPT"
bot_message <- "Hello!"

chave_acesso = Sys.getenv("APP_ACESS_KEY")


if (file.exists(csv_path)) {
  file.remove(csv_path)
}

chat_data <- shinyChatR:::CSVConnection$new(csv_path, n = 100)

ui <- fluidPage(
  useShinyjs(),
  titlePanel("ggplotGPT"),
  sidebarLayout(
    sidebarPanel(
      passwordInput("chave_acesso", "Chave de Acesso:", value = ""),
      actionButton("start_chat", "Iniciar Chat", disabled = TRUE),
      width = 3
    ),
    mainPanel(
      hidden(div(id = "chat_panel",
                 chat_ui(id = id_chat, ui_title = "Chat Area", height = "600px", width = "100%")
      )),
      width = 9
    )
  )
)

server <- function(input, output, session) {
  
  observe({
    if (nchar(input$chave_acesso) > 0 & input$chave_acesso == chave_acesso) {
      shinyjs::enable("start_chat")
    } else {
      shinyjs::disable("start_chat")
    }
  })
  
  observeEvent(input$start_chat, {
    shinyjs::show("chat_panel")
  })
  
  chat <- chat_server(
    id = id_chat,
    chat_user = chat_user,
    csv_path = csv_path 
  )
  
  observeEvent(input[[id_sendMessageButton]], {
    dt <- chat_data$get_data()
    bot_message <- obter_resposta_chat(dt[.N, text], id_chat)
    chat_data$insert_message(user = bot,
                            message = bot_message,
                            time = strftime(Sys.time()))
  })
}

shinyApp(ui, server)