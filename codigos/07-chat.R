resposta = reticulate::py$obter_resposta("Qual a capital do Ceará?")
resposta$answer

resposta = reticulate::py$obter_resposta("Como fazer um boxplot?")
resposta$answer

iniciar_chat <- function(id_sessao = "abc123") {
  print("Iniciando chatGGPLOT, digite 'sair' para terminar.")
  
  while(TRUE){
    pergunta = readline("Diga: ")
    
    if (stringr::str_to_lower(pergunta) == 'sair'){
      print("Encerrando o chatGGPLOT.")
      break
    }
    
    resultado = reticulate::py$obter_resposta(pergunta, id_sessao)
    print(resultado$answer)
  }
}

iniciar_chat()