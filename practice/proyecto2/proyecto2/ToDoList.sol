///SPDX-License-Identifier: MIT
pragma solidity 0.8.30;
/**
    *@title Contrato ToDoList
    *@notice Contrato para organizar tareas
    *@author xxxxx
*/
contract ToDoList {
    ///@notice Estructura para almacenar información de tareas
    struct Tarea {
        string descripcion;
        uint256 tiempoDeCreacion;
        bool completada;
    }

    ///@notice Array para almacenar la estructura de datos
    Tarea[] public s_tareas;

    ///@notice Evento emitido cuando se añade una nueva tarea
    event ToDoList_TareaAnadida(Tarea tarea);
    ///@notice Evento emitido cuando una tarea es completada y eliminada
    event ToDoList_TareaCompletadaYEliminada(string _descripcion);

    /**
        *@notice Función para añadir tareas al almacenamiento del contrato
        *@param _descripcion La descripción de la tarea que se está añadiendo
    */
    function setTarea(string memory _descripcion) external {
        Tarea memory tarea = Tarea ({
            descripcion: _descripcion,
            tiempoDeCreacion: block.timestamp,
            completada: false
        });

        s_tareas.push(tarea);

        emit ToDoList_TareaAnadida(tarea);
    }

    /*
        *@notice Función para eliminar tareas completadas
        *@param _Descripción de la tarea que será eliminada
    */

    function eliminarTarea(string memory _descripcion) external {
        //Guarda en una variable local cuántas tareas hay para no leer la longitud en cada iteración
        uint256 tamanio = s_tareas.length;

        // bucle: recorrer todas las tareas del array, desde i = 0 hasta i = tamanio - 1.
        for(uint256 i = 0; i < tamanio; ++i){
            if(keccak256(abi.encodePacked(_descripcion)) == keccak256(abi.encodePacked(s_tareas[i].descripcion))){
                /*s_tareas[i].descripcion obtiene la descripción de la tarea actual. 
                Como no se pueden comparar string directamente en Solidity convertir ambos strings en un hash con keccak256, y comparar los hashes.
                Cuando If es verdadero entra al bucle y haces swap and pop.
                */
                 
                s_tareas[i] = s_tareas[tamanio - 1];
                s_tareas.pop();

                emit ToDoList_TareaCompletadaYEliminada(_descripcion);
                return;
            }
        }
    }
    /* en clase se agregó una nueva funcionalidad "completar tarea"
    en lugar de usar  abi.encodePacked() usamos bytes() q es ligeramente más barato en gas
    */
    function completarTarea(string calldata _descripcion) external {
        uint256 len = s_tareas.length;
        for (uint256 i = 0; i < len; ) {
            if (keccak256(bytes(s_tareas[i].descripcion)) == keccak256(bytes(_descripcion))) {
                s_tareas[i].completada = true;
                emit ToDoList_TareaCompletadaYEliminada(_descripcion);
                break;
            }
            unchecked { ++i; }
        }
    }

    /**
        *@notice Función que retorna todas las tareas almacenadas en el array s_tareas
        *@return tarea_ Array de tareas
    */
    function getTarea() external view returns(Tarea[] memory tarea_){
        tarea_ = s_tareas;
    }
}

/* En clase se añade index para poder interactuar con las funciones y evitar tener que estar mencionando la descripción de las tareas para poder completarlas o mismo eliminarlas*/


