//Parámetros Globlales
`timescale 1ns / 1ps

//Tiempos del Reloj
`define Tclk1 7  //reloj en alto
`define Tclk0 43 //reloj en bajo

//Tiempo para inicializar a cero las señales primarias Clock y Reset
`define Tind 5

//Reset
`define Tres0 2 //Tiempo que Reset permanece en 0 antes de ir a 1
`define Tres1 100 //Tiempo que Reset permanece en 1 antes de devolverse a 0

//Retardo de la lógica combinacional
`define Tlc 23
