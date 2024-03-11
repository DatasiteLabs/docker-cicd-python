from dataclasses import dataclass

__all__ = ('Summation', )

@dataclass
class Summation:
    augend: int
    addend: int
    sum: int