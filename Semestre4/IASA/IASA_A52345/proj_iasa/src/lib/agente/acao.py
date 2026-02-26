from abc import ABC
"""
Aqui estamos a definir uma interface, para esse efeito usei a classe abstrata Acao, que representa uma ação que o agente pode executar.
Como já escrevi no ficheiro controlo.py, uma classe abstrata é aquela que não pode ser instanciada diretamente, ou seja, não podemos criar objetos a partir dela.
"""
class Acao(ABC):
    """Interface que representa uma ação"""