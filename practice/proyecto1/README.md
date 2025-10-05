# Proyecto Solidity - Contrato "Mensaje"

Esta práctica consiste en un contrato inteligente simple escrito en Solidity que permite guardar y consultar un mensaje en la blockchain.  
Cada vez que se actualiza el mensaje, se emite un evento que puede ser visto en los logs de la transacción.

## 🚀 Clonar y ejecutar el proyecto

1. Clonar el repositorio.
2. Abrir el archivo Mensaje.sol en un IDE compatible con Solidity, por ejemplo Remix.
3. Compilar el contrato con la versión 0.8.30 de Solidity.
4. Implementar en una red de prueba (ejemplo: Sepolia) conectando MetaMask al IDE.


🔗 Contrato en Block Explorer

El contrato está desplegado en la red Sepolia Testnet y puede consultarse en el siguiente enlace:

https://sepolia.etherscan.io/address/0x1c43501190043f51f12eac4623aa953d5e7b6b0b

📚 Descripción técnica

Lenguaje: Solidity 0.8.30

Funciones principales:

setMensaje(string _mensaje): actualiza el mensaje y emite un evento.

getMensaje(): devuelve el mensaje almacenado.

Evento: Mensaje_MensajeActualizado(string mensaje): se emite cada vez que el mensaje cambia.





