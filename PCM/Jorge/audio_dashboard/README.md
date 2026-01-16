# 🎵 Audio Content Dashboard

![Status](https://img.shields.io/badge/Status-Completed-success)
![Tech](https://img.shields.io/badge/Built%20With-Quarto%20%7C%20OJS-blue)
![Style](https://img.shields.io/badge/Style-Dark%20Mode-black)

Este projeto é um dashboard analítico interativo para conteúdos de áudio, desenvolvido para visualizar métricas técnicas de músicas (BPM, Energia, Popularidade) numa interface moderna e responsiva.

## 📸 Preview

![Screenshot do Dashboard](https://imgur.com/evFTFc8)



## ✨ Descrição das Funcionalidades

O dashboard oferece uma experiência integrada de análise e reprodução:

1.  **Navegação Interativa:**
    * Uma lista lateral permite navegar por todas as músicas do dataset.
    * Seleção visual com destaque em verde para indicar a faixa ativa.
    * Atualização instantânea dos detalhes sem recarregar a página.

2.  **Player de Áudio Integrado:**
    * Incorporação direta do **Spotify Embed**. Ao clicar numa música na lista, o player atualiza automaticamente o `src` para permitir a reprodução de uma demonstração da faixa selecionada.

3.  **Visualização de Métricas Técnicas:**
    * Exibição de metadados: Artista, Álbum, Ano e Duração (convertida automaticamente de ms para mm:ss).
    * **Audio Features:** Cartões para dados quantitativos como **BPM**, **Energia**, **Dançabilidade** e **Felicidade**.

---

## 🎨 Explicação das Decisões de Design

O design visual e arquitetural foi guiado pelos seguintes princípios:

### 1. Estética (Dark UI)
* **Decisão:** Utilização de um fundo preto absoluto (`#000000`) e cinzas escuros (`#121212`), substituindo o padrão claro do Quarto.
* **Motivo:** Alinhar a interface com o ambiente visual a que os utilizadores de música já estão habituados (Spotify, Apple Music). O contraste elevado com o texto branco e o acento verde (`#1db954`) guia o olhar para as informações importantes.

### 2. OJS para Reatividade
* **Decisão:** Uso de OJS (`viewof`, `html`).
* **Motivo:** Permite que toda a interatividade (clicar na lista -> mudar o player) aconteça no **lado do cliente** (browser). O resultado é um dashboard extremamente rápido e leve.

### 3. Layout de Colunas Assimétricas (35% / 65%)
* **Decisão:** A coluna da esquerda (lista) é mais estreita que a da direita (detalhes).
* **Motivo:** A lista serve apenas para navegação rápida. O foco principal é o conteúdo (Player e Métricas), que necessita de mais espaço horizontal para exibir as informações de forma legível sem quebras de linha indesejadas.

### 4. Altura Dinâmica (`vh`)
* **Decisão:** Definição da altura da lista como `85vh` em vez de pixels fixos.
* **Motivo:** Garante que a lista ocupa a altura do ecrã do utilizador, independentemente do dispositivo, evitando scrollbars duplas (uma na lista, outra na página) que prejudicam a usabilidade.

---

## 🚀 Instruções de Execução

### Pré-requisitos
* Ter o **[Quarto CLI](https://quarto.org/docs/get-started/)** instalado.
* Um editor de código (VS Code recomendado).

### Estrutura de Ficheiros
Certifique-se de que a pasta do projeto contém:
1.  `dashboard.qmd` (O código fonte).
2.  `dados.json` (O dataset).

### Formato do JSON (`dados.json`)
O ficheiro de dados deve seguir estritamente este formato (valores de exemplo):
```json
[
  {
    "Música": "Título",
    "Artista": "Nome",
    "Album": "Nome do Álbum",
    "id": "id da música (spotify)", 
    "img": "URL_DA_IMAGEM", 
    "Duracao": 200000, 
    "Year": 2024,
    "BPM": 120,
    "Popularidade": 80,
    "Energia": 0.8,
    "Danceability": 0.7,
    "Hapiness": 0.6
  }
]
```
As estatisticas de aúdio (BPM, Popularidade, Energia, Dançabilidade, Felicidade), foram retiradas do website [Chosic](https://www.chosic.com/).
(Nota: O id deve ser apenas o código alfanumérico, não o link completo).