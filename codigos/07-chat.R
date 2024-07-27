library(reticulate)
resposta = py$obter_resposta("Qual a capital do Ceará?")
resposta$answer

iniciar_chat <- function(id_sessao = "abc123") {
  print("Iniciando chatGGPLOT, digite 'sair' para terminar.")
  
  while(TRUE){
    pergunta = readline("Diga: ")
    
    if (stringr::str_to_lower(pergunta) == 'sair'){
      print("Encerrando o chatGGPLOT.")
      break
    }
    
    resultado = py$obter_resposta(pergunta, id_sessao)
    print(resultado$answer)
  }
}

iniciar_chat()


# tarefas:
# 1. OK apagar versao antiga
# 2. subir versao nova no github
# 3. atualizar tutorial
# 4. fazer slides com conceitos iniciais
  # - LLM
  # - prompt
  # - fine tuning
  # - rag
  # - embedding
  # - ggplot2
