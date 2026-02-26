from abc import ABC
"""
Aqui estamos a definir uma interface, para esse efeito usei a classe abstrata Prececao, que representa uma percepção do ambiente que o agente pode obter.
Como já escrevi no ficheiro controlo.py, uma classe abstrata é aquela que não pode ser instanciada diretamente, ou seja, não podemos criar objetos a partir dela.
"""
class Prececao(ABC):
    """Interface que representa uma percepção"""