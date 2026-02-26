"""
A biblioteca abc é usada para criar classes abstratas em Python. 
Ela fornece a funcionalidade necessária para definir métodos abstratos, que são métodos que devem ser implementados por subclasses.
"""
from abc import ABC, abstractmethod
"""
O agente é a entidade que interage com o ambiente, que toma decisões com base nas perceções e executa ações. Ele é composto por um controlo, que é responsável por processar as perceções e determinar as ações a serem tomadas. O agente pode ser implementado de diversas formas, 
dependendo do tipo de ambiente e das tarefas que ele precisa realizar.

Usamos uma abstração de agente para permitir a flexibilidade na implementação de diferentes 
tipos de agentes, como agentes reativos, agentes baseados em modelos, agentes baseados em objetivos, entre outros. 

A interface do agente define os métodos que devem ser implementados para que o agente possa perceber o ambiente e atuar de acordo com as decisões tomadas pelo controlo.
"""
class Agente(ABC):
    def __init__(self,controlo):
        self._controlo = controlo

    """
    Usamos o @abstractmethod para indicar que os métodos _percecionar e _atuar devem ser implementados pelas subclasses do agente. 
    O método executar é responsável por coordenar o processo de percepção e atuação do agente, 
    chamando os métodos apropriados para obter a perceção do ambiente e executar a ação determinada pelo controlo.
    """
    @abstractmethod
    def _percecionar(self):
        """Obter perceção do ambiente"""

    @abstractmethod
    def _atuar(self, acao):
        self._acao = acao

    def executar(self):
        """Executar passo de processamento"""