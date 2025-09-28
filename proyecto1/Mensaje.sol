// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

contract Mensaje {

    string internal s_mensaje;

    event Mensaje_MensajeActualizado(string mensaje);
    
    function setMensaje(string calldata _mensaje) external {
		s_mensaje = _mensaje;
        emit Mensaje_MensajeActualizado(_mensaje);
    }
    function getMensaje() public view returns(string memory mensaje_){
		mensaje_ = s_mensaje;
	}

}
