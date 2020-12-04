***Settings***

Documentation   Documentação da API: http://fakerestapi.azurewebsites.net/index.html

Library     RequestsLibrary
Library     Collections

***Variables***
${URL_API}     http://fakerestapi.azurewebsites.net/api/v1/
&{BOOK_15}     id=15
...            title=Book 15

&{BOOK_500}    id=500
...            title=Teste
...            description=teste
...            pageCount=12
...            excerpt=teste
...            publishDate=2020-12-03T20:29:45.795Z

&{BOOK_100}     id=100
...             title=Book 100 alterado
...             description=Descrição do book 100 alteada
...             pageCount=600
...             excerpt=Resumo do book 100 alteado
...             publishDate=2017-04-26T15:58:14.765Z


***Keywords***
#Setup e teardowns
Conectar a API
    Create Session      fakerestapi     ${URL_API}
    ${HEADERS}     Create Dictionary    content-type=application/json
    Set Suite Variable    ${HEADERS}

#Ações

Requisitar todos os livros
    ${RESPOSTA}    Get Request      fakerestapi     Books  
    Log         ${RESPOSTA.text}
    Set Test Variable      ${RESPOSTA}


Requisitar o livro "${ID_LIVRO}"
    ${RESPOSTA}    Get Request      fakerestapi     Books/${ID_LIVRO} 
    Log         ${RESPOSTA.text}
    Set Test Variable      ${RESPOSTA}

Cadastrar um novo livro  
    ${RESPOSTA}    Post Request      fakerestapi     Books  
    ...            data={"id": 500,"title": "Teste","description": "teste","pageCount": 12,"excerpt": "teste","publishDate": "2020-12-03T20:29:45.795Z"}
    ...            headers=${HEADERS}
    Log            ${RESPOSTA.text}
    Set Test Variable   ${RESPOSTA}

Alterar o livro "${ID_LIVRO}"
    ${RESPOSTA}    Put Request    fakerestapi    Books/${ID_LIVRO}
    ...                           data={"id": ${BOOK_100.id},"title": "${BOOK_100.title}","description": "${BOOK_100.description}","pageCount": ${BOOK_100.pageCount},"excerpt": "${BOOK_100.excerpt}","publishDate": "${BOOK_100.publishDate}"}
    ...                           headers=${HEADERS}
    Log            ${RESPOSTA.text}
    Set Test Variable    ${RESPOSTA}

Excluir o livro "${ID_LIVRO}"
    ${RESPOSTA}    Delete Request    fakerestapi    Books/${ID_LIVRO}
    Log            ${RESPOSTA.text}
    Set Test Variable    ${RESPOSTA}

#Conferências

Conferir status code
    [Arguments]     ${STATUSCODE_DESEJADO}
    Should Be Equal As Strings      ${RESPOSTA.status_code}     ${STATUSCODE_DESEJADO}
    Log         ${RESPOSTA.status_code} 

Conferir o reason
    [Arguments]     ${REASON_DESEJADO}
    Should Be Equal As Strings      ${RESPOSTA.reason}      ${REASON_DESEJADO}

Conferir se retorna uma lista com "${QTDE_LIVROS}" livros
    Length Should Be        ${RESPOSTA.json()}      ${QTDE_LIVROS}

Conferir se retorna todos os dados corretos do livro 15
    Dictionary Should Contain Item      ${RESPOSTA.json()}        id            ${BOOK_15.id}    
    Dictionary Should Contain Item      ${RESPOSTA.json()}        title         ${BOOK_15.title} 
    Should Not Be Empty             ${RESPOSTA.json()["description"]}     

Conferir se retorna todos os dados cadastrados do livro "${ID_LIVRO}"
    Conferir livro    ${ID_LIVRO}

Conferir se retorna todos os dados alterados do livro "${ID_LIVRO}"
    Conferir livro    ${ID_LIVRO}
    
Conferir livro
    [Arguments]     ${ID_LIVRO}
    Dictionary Should Contain Item    ${RESPOSTA.json()}    id              ${BOOK_${ID_LIVRO}.id}
    Dictionary Should Contain Item    ${RESPOSTA.json()}    title           ${BOOK_${ID_LIVRO}.title}
    Dictionary Should Contain Item    ${RESPOSTA.json()}    description     ${BOOK_${ID_LIVRO}.description}
    Dictionary Should Contain Item    ${RESPOSTA.json()}    pageCount       ${BOOK_${ID_LIVRO}.pageCount}
    Dictionary Should Contain Item    ${RESPOSTA.json()}    excerpt         ${BOOK_${ID_LIVRO}.excerpt}
    Dictionary Should Contain Item    ${RESPOSTA.json()}    publishDate     ${BOOK_${ID_LIVRO}.publishDate}

Conferir se excluiu o livro "${ID_LIVRO}"
    Should Be Empty     ${RESPOSTA.content}