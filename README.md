# 🚪 Artix-7 Garage Controller

Este proyecto consiste en el desarrollo de un sistema de control automatizado para una puerta de garaje basado en la FPGA **Artix-7**. El sistema utiliza lógica **VHDL** para gestionar periféricos de actuación y sensores de seguridad, ofreciendo una solución síncrona, robusta y modular.

## 🕹️ Características del Proyecto

- **Control Síncrono**: Implementación de una **FSM de tipo Moore** para una gestión de estados sin fallos lógicos.
- **Seguridad Activa**: Detección de obstáculos mediante sensor **HC-SR04** con reapertura automática instantánea.
- **Movimiento Preciso**: Control de posición de un servomotor SG90 mediante señales **PWM de 50 Hz**.
- **Interfaz Alfanumérica**: Visualización de estados (**OPEN, CLSE, CLOS, Err**) en displays de 7 segmentos.
- **Maqueta Mecánica**: Diseño físico con acoplamiento directo entre el servo y la puerta.

## 🛠️ Especificaciones Técnicas

- **FPGA**: Xilinx Artix-7.
- **Entorno**: Xilinx Vivado.
- **Módulos Críticos**:
  - `Pulse_Generator`: Divisor de frecuencia para base de tiempos de 1 ms.
  - `Timer`: Temporizador parametrizado para esperas de 5 s.
  - `Servo_Controller`: Generador PWM con resolución de microsegundos.
  - `Ultrasonic_sensor`: Driver de disparo y medición de eco.
- **Protección**: Sincronizadores y Debouncers en todas las entradas físicas.

## 📂 Estructura de Desarrollo

El repositorio refleja la evolución del diseño síncrono:

1. **v1 (Lógica)**: Diseño de la FSM central y validación por testbench.
2. **v2 (Actuación)**: Implementación de tiempos y controlador PWM.
3. **v3 (Seguridad)**: Integración del driver de ultrasonidos y lógica de interrupción.
4. **v4 (Final)**: Versión definitiva con interfaz de displays y esquemático RTL completo.

## 🏗️ Montaje Final

La electrónica se conecta mediante el puerto **Pmod JA**:

- **Pin 1**: Señal PWM (Servo).
- **Pin 2**: Trigger (Ultrasonidos).
- **Pin 3**: Echo (Ultrasonidos) *con resistencia de 1kΩ para protección 5V -> 3.3V*.

---
*Desarrollado para la asignatura de Sistemas Electrónicos Digitales por Laura Hernández, Manuel Sánchez y Pablo García (Grupo 31). Tutor: Giuseppe.*
