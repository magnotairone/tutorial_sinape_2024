library(shiny)
library(shinyChatR)
library(shinyjs)  # Inclui o shinyjs para manipulação de elementos no UI
library(reticulate)

reticulate::use_virtualenv("langchain_rag")

reticulate::py_run_file("chat.py")

# reticulate::py_install(packages = c("langchain-openai"), envname = "langchain_rag")


obter_resposta_chat <- function(pergunta, id_sessao = "abc123"){
  resultado = py$obter_resposta(pergunta, id_sessao)
  return(resultado$answer)
}

csv_path <- "chat.csv"
id_chat <- "chat1"
id_sendMessageButton <- paste0(id_chat, "-chatFromSend")
chat_user <- "Você"
bot <- "MeuGPT"
bot_message <- "Hello!"


# Drop this if the chat log shall not be deletado
if (file.exists(csv_path)) {
  file.remove(csv_path)
}

ChatData <- shinyChatR:::CSVConnection$new(csv_path, n = 100)

get_answer <- function(message){
  return(paste0("minha resposta para '",message,"': nao sei de nadaa kkkk"))
}

# Define UI
ui <- fluidPage(
  useShinyjs(),  # Ativa o uso do shinyjs
  titlePanel("Chat sobre seu Arquivo"),
  sidebarLayout(
    sidebarPanel(
      passwordInput("api_openai", "Chave API OpenAI:", value = ""),
      passwordInput("api_pinecone", "Chave API Pinecone:", value = ""),
      actionButton("start_chat", "Iniciar Chat", disabled = TRUE)
    ),
    mainPanel(
      hidden(div(id = "chat_panel",  # Esconde o painel de chat inicialmente
                 chat_ui(id = id_chat, ui_title = "Chat Area")
      ))
    )
  )
)

# Define server logic
server <- function(input, output, session) {
  # Enable the chat button only if both API keys are provided
  observe({
    if (nchar(input$api_openai) > 0 && nchar(input$api_pinecone) > 0) {
      shinyjs::enable("start_chat")
    } else {
      shinyjs::disable("start_chat")
    }
  })
  
  # Initialize chat server and show the chat panel only after the button is clicked
  observeEvent(input$start_chat, {
    shinyjs::show("chat_panel")  # Mostra o painel de chat
    # chat <- chat_server(
    #   id = id_chat,
    #   chat_user = chat_user,
    #   csv_path = csv_path  # Usando CSV para armazenar mensagens
    # )
  })
  
  chat <- chat_server(
    id = id_chat,
    chat_user = chat_user,
    csv_path = csv_path  # Using CSV to store messages
  )
  
  # Observe incoming messages and respond
  observeEvent(input[[id_sendMessageButton]], {
    dt <- ChatData$get_data()
    bot_message <- obter_resposta_chat(dt[.N, text], id_chat)#get_answer(dt[.N, text])
    ChatData$insert_message(user = bot,
                            message = bot_message,
                            time = strftime(Sys.time()))
  })
  
  reticulate::py_run_string("
print('Estou em Fortaleza!') 
  ")
}

# Run the application
shinyApp(ui, server)



# OLD
# library(shiny)
# library(shinyChatR)
# 
# csv_path <- "chat.csv"
# id_chat <- "chat1"
# id_sendMessageButton <- paste0(id_chat, "-chatFromSend")
# chat_user <- "Você"
# bot <- "MagnoGPT"
# bot_message <- "Hello!"
# 
# # drop this if the chat log shall not be deleted
# if (file.exists(csv_path)) {
#   file.remove(csv_path)
# }
# 
# ChatData <- shinyChatR:::CSVConnection$new(csv_path, n = 100)
# 
# get_answer <- function(message){
#   return(paste0("minha resposta para '",message,"': nao sei de nadaa kkkk"))
# }
# 
# # Define UI
# ui <- fluidPage(titlePanel("Chatbot Demo"),
#                 chat_ui(id = id_chat, ui_title = "Chat Area"))
# 
# # Define server logic
# server <- function(input, output, session) {
#   
#   # Initialize chat server
#   chat <- chat_server(
#     id = id_chat,
#     chat_user = chat_user,
#     csv_path = csv_path  # Using CSV to store messages
#   )
#   
#   #
#   
#   # Observe incoming messages and respond
#   observeEvent(input[[id_sendMessageButton]], {
#     dt = ChatData$get_data()
#     bot_message <- get_answer(print(dt[.N, text]))
#     ChatData$insert_message(user = bot,
#                             message = bot_message,
#                             time = strftime(Sys.time()))
#   })
#   
# }
# 
# # Run the application
# shinyApp(ui, server) 
