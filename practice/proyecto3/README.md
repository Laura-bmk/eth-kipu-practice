# Donations - Contrato Solidity

## 📘 Descripción

Este proyecto implementa un contrato inteligente en Solidity que permite recibir donaciones en Ether y registrar los aportes de cada usuario.  
El beneficiario, definido al momento del despliegue, puede retirar fondos acumulados.

Incluye:
- Variable `immutable` para el beneficiario.
- Registro de donaciones mediante `mapping`.
- Eventos para cada donación y retiro.
- Errores personalizados y modificador de acceso.
- Función para retiro de donaciones.

---

## 🧩 Instrucciones de despliegue y prueba

### 1️⃣ Clonar el repositorio
```bash
git clone https://github.com/Laura-bmk/eth-kipu-practice.git

    Luego ingresar al proyecto 3

cd eth-kipu-practice/practice/proyecto3

2️⃣ Compilar y desplegar en Remix IDE

Ir a Remix

Crear el archivo Donations.sol y pegar el código.

Compilar con la versión 0.8.30

En “Deploy & Run Transactions”:

Environment: Injected Provider - MetaMask

Constructor → _beneficiary: pegar tu dirección de MetaMask

Deploy y confirmar en MetaMask.

3️⃣ Probar funciones

donate() → Enviar Ether.

withdraw → El beneficiario retira fondos.

BENEFICIARY → Muestra la dirección beneficiaria.

donations(address) → Muestra cuánto donó cada dirección.


🌐 Información del despliegue

Red: Sepolia Testnet

Contrato desplegado en: 0x07d481291D94b5c3A86451D239752694fC7c5327

Compilador: Solidity 0.8.x

IDE utilizado: Remix IDE