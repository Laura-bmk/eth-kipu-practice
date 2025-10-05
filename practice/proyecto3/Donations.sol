/*
Este contrato se llama Donations: permite que cualquiera envíe Ether (donaciones) y lleve la cuenta de cuánto donó cada dirección; sólo una dirección llamada BENEFICIARY puede retirar todo el dinero acumulado.
*/


// SPDX-License-Identifier: MIT 
pragma solidity  0.8.30;

contract Donations {
   address immutable public BENEFICIARY; // eficiente a nivel de gas
   mapping (address => uint256) public donations;
//BENEFICIARY: dirección (wallet) que puede retirar. immutable => se fija una sola vez al desplegar el contrato (en el constructor) y después no cambia.
//donations: por cada dirección, guarda un número (la cantidad donada)

   event DonationReceived(address sender, uint256 amount);
   event WithdrawalPerformed(address beneficiary, uint256 amount);


//Los errores personalizados para devolver que algo falló son más económicos en gas que usar require("texto...")
   error TransactionFailed(bytes reason);
   error UnauthorizedWithdrawer(address caller, address beneficiary);

   modifier onlyBeneficiary() {
      if (msg.sender != BENEFICIARY) revert UnauthorizedWithdrawer(msg.sender, BENEFICIARY);
      _;
   }
/*
    msg.sender es quien llama la función.
    onlyBeneficiary verifica que quien llama sea el BENEFICIARY; si no, revierte (lanza error) y la acción no se ejecuta. 
    El _ indica "ejecutá la función aquí" si pasa la verificación.
*/


   constructor(address _beneficiary) {
      BENEFICIARY = _beneficiary;
   }

   //Al crear (desplegar) el contrato, quien lo despliega pasa una dirección que se guarda en BENEFICIARY. 
   //Desde entonces esa dirección será la que pueda retirar.

   receive() external payable {
      donations[msg.sender] += msg.value;
      emit DonationReceived(msg.sender, msg.value);
   }
/* 
receive se activa cuando alguien manda Ether al contrato sin datos adicionales.
payable permite recibir Ether.
msg.value es cuánto Ether (en wei, unidad mínima) se envió.
Se suma esa cantidad al registro donations del remitente y se emite el evento.
*/
   fallback() external payable {
      donations[msg.sender] += msg.value;
      emit DonationReceived(msg.sender, msg.value);
   }
/*
Se ejecuta si se manda Ether con datos o si se llama a una función inexistente. 
También acepta Ether y registra la donación (igual que receive).
*/

   function donate() external payable {
      donations[msg.sender] += msg.value;
      emit DonationReceived(msg.sender, msg.value);
   }

// Permite que cualquiera pueda llamar y enviar Ether. Hace exactamente lo mismo que receive/fallback, pero la llamás por su nombre.

   function withdraw() external onlyBeneficiary returns(bytes memory data){
      emit WithdrawalPerformed(BENEFICIARY, address(this).balance); // efect
      data = _transferEth(BENEFICIARY, address(this).balance); // interacion
      return data;
   }

/*
onlyBeneficiary asegura que sólo el beneficiario puede ejecutar esto.
address(this).balance es TODO el Ether guardado en el contrato.
Emite un evento y luego llama a _transferEth para enviar todo el dinero al BENEFICIARY.
Devuelve data, que es la respuesta de la llamada.
*/

/*Función moficada para retirar un MONTO ESPECÍFICO:
function withdraw(uint256 amount) external onlyBeneficiary returns (bytes memory data) {
    // checks: validar monto no nulo y que haya fondos suficientes
    if (amount == 0) revert TransactionFailed(bytes("amount is zero"));
    uint256 balance = address(this).balance;
    if (amount > balance) revert TransactionFailed(bytes("insufficient balance"));

    // interacción externa: intento de enviar el amount al beneficiario
    data = _transferEth(BENEFICIARY, amount);

    // evento: registramos que la retirada se realizó correctamente
    emit WithdrawalPerformed(BENEFICIARY, amount);

    return data; //opcional
}

 */

   function _transferEth(address to, uint256 amount) private returns (bytes memory) {
      (bool success, bytes memory data) = to.call{value:amount}("");
      if(!success) revert TransactionFailed(bytes("call failed"));
      return data;
   }
/*
usa call (llamada de bajo nivel) para mandar Ether a to (se podría agregar payable(to).call... para asegurar que la direccion reciba ether)
call devuelve success (si la operación fue ok) y data (lo que devuelva la llamada).
Si success es falso, revierte con el error TransactionFailed(...). Nota: call failed" es un string, no bytes.
*/


}
 