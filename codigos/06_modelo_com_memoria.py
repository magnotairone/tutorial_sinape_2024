from langchain_core.prompts import ChatPromptTemplate, MessagesPlaceholder
from langchain.chains import create_retrieval_chain
from langchain.chains.combine_documents import create_stuff_documents_chain
from langchain_core.runnables.history import RunnableWithMessageHistory
from langchain_core.chat_history import BaseChatMessageHistory
from langchain_community.chat_message_histories import ChatMessageHistory
from langchain_core.prompts import ChatPromptTemplate, MessagesPlaceholder
from langchain.chains import create_history_aware_retriever

llm = ChatOpenAI(
  model = "gpt-4o-mini", 
  temperature = 0
)

recuperador = base_conhecimento.as_retriever()

prompt_contextualizacao = (
  "Dado um histórico de chat e a última pergunta do usuário "
  "que pode referenciar o contexto no histórico do chat, "
  "formule uma pergunta independente que possa ser compreendida "
  "sem o histórico do chat. NÃO responda à pergunta, "
  "apenas reformule-a se necessário e, caso contrário, retorne-a como está."
)

prompt_template = ChatPromptTemplate.from_messages(
  [
    ("system", prompt_contextualizacao),
    MessagesPlaceholder("chat_history"),
    ("human", "{input}"),
  ]
)

recuperador_historico = create_history_aware_retriever(
    llm, recuperador, prompt_template
)

prompt_final = (
  "Você é um assistente para tarefas de perguntas e respostas sobre o ggplot2. "
  "Use os seguintes trechos de contexto recuperado para responder "
  "à pergunta. Se você não souber a resposta, diga que você "
  "não sabe. Se a pergunta estiver fora do contexto recuperado, "
  "não responda e apenas diga que está fora do contexto."
  "A sua resposta deve ser em portugês brasileiro.\n\n"
  "{context}"
)

qa_prompt = ChatPromptTemplate.from_messages(
    [
        ("system", prompt_final),
        MessagesPlaceholder("chat_history"),
        ("human", "{input}"),
    ]
)

cadeia_perguntas_e_respostas = create_stuff_documents_chain(
  llm, 
  qa_prompt
)

cadeia_rag = create_retrieval_chain(
  recuperador_historico, 
  cadeia_perguntas_e_respostas
)

sessoes = {}

def obter_historico_sessao(id_sessao: str) -> BaseChatMessageHistory:
  if id_sessao not in sessoes:
    sessoes[id_sessao] = ChatMessageHistory()
  return sessoes[id_sessao]

chat_cadeia_rag = RunnableWithMessageHistory(
    cadeia_rag,
    obter_historico_sessao,
    input_messages_key = "input",
    history_messages_key = "chat_history",
    output_messages_key = "answer",
)

def obter_resposta(pergunta, id_sessao = "abc123"):
  resultado = chat_cadeia_rag.invoke(
    {"input": pergunta},
    config = {"configurable": {"session_id": id_sessao}},
  )
  return resultado
