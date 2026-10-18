# Fazendeiro — estudo de animação

Referência: Fazendeiro Clássico do jogo, jovem sem barba, chapéu marrom de aba larga, camisa xadrez azul, jeans e botas. Vista frontal em três quartos, luz superior esquerda. Produção no Aseprite AI Artist, modo headless.

Canvas 128×128, pés em (64,96), offset de gameplay (0,-16). Figura com aproximadamente 64 px de altura; contorno quente de 1 px, detalhes em clusters e transparência binária. A reconstrução simplifica o excesso de variações de cor da referência para dar estabilidade às formas em movimento.

Camadas: sombra, perna distante, braço distante, tronco, perna próxima, cabeça, chapéu, braço próximo e efeitos. Sem arma desenhada no corpo: as armas continuam pertencendo ao sistema de combate.

| Estado | Poses e intenção | Reprodução |
|---|---|---|
| idle | Respiração pequena e piscada; pés firmes. | 8 quadros em loop. |
| walk | Contato, apoio, passagem e elevação por perna; braços opostos às pernas. | 8 quadros em loop; duração por quadro. |
| run | Inclinação para frente, braços dobrados, joelhos altos e fase aérea. | 8 quadros em loop; duração por quadro. |
| idle_hat | Levantar o braço, ajeitar/erguer a aba do chapéu e voltar à pose neutra. | 14 quadros, uma vez; interrompível por movimento/dano. |
| idle_swat | Olhar uma mosquinha, afastá-la com a mão, fazer expressão irritada e relaxar. | 14 quadros, uma vez; interrompível por movimento/dano. |
| death | Sustinho, desequilíbrio, queda lateral, chapéu solto e corpo imóvel. | 12 quadros, sem loop; segura o último. |

Gestos de descanso alternados após alguns segundos parado. Eles não bloqueiam o controle. Corrida é um estado visual da movimentação existente no joystick, sem novo bônus de velocidade. Outros personagens mantêm suas famílias visuais. Morte mantém a pausa e o pagamento atuais; só sua apresentação muda.

Paleta e poses ficam reproduzíveis em `farmer-design.mjs`. Exportar fonte `.aseprite` com camadas/tags, atlas, PNGs individuais, GIFs e pranchas para inspeção. Sem interpolação óptica neste teste: articulações, olhos e contornos precisam de desenho estável.
