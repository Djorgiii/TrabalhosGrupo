from abc import ABC, abstractmethod

"""
Aqui estamos a definir a classe abstrata Controlo, que é responsável por processar as perceções e determinar as ações a serem tomadas pelo agente.
Uma classe abstrata é aquela que não pode ser instanciada diretamente, ou seja, não podemos criar objetos a partir dela. 
Ela serve como um modelo para outras classes que herdam dela e implementam os métodos abstratos definidos na classe base.
"""
class Controlo(ABC):
    """
    O metodo processar é um método abstrato, o que significa que ele deve ser implementado por qualquer classe que herde de Controlo.
    """
    @abstractmethod
    def processar(self, percecao):
        """Processar percepção e retornar ação"""