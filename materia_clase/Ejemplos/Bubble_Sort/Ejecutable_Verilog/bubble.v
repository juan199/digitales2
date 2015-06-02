module bubble;

reg [31:0] x [15:0];  //Arreglo que contiene 16 registros de 32 bits cada uno
reg [31:0] temp;      //registro para sostener temporalmente un dato
reg cambio;           //Indica si se ha hecho un intercambio
integer j,            //Indice
        n,            //Numero de elementos en x[]
        pasadas;      //Numero de pasadas que hay que hacer sobre el arreglo
integer i,            //Indice
        semilla;      //Semilla para generador de numeros aleatorios

initial
  begin
    //Iniciar el arreglo x con valores aleatorios
    semilla = 1;
    for (i=0; i<16; i=i+1)
      begin
        x[i] = $random(semilla);
        $display("%d", x[i]);
      end

    $display("--- Inicia el ordenamiento ---");

    //Ordenar numeros en x[]
    n = 16;  //Numero de elementos en el arreglo x[]
    cambio = 1; //Forzar a verdadero para que comience a funcionar
    for (pasadas=0; pasadas<n-1 && cambio; pasadas=pasadas+1)
      begin
        cambio = 0;
        for (j=0; j<n-pasadas-1; j=j+1)
          begin
            if (x[j] > x[j+1])
              begin
                cambio = 1;
                temp = x[j];
                x[j] = x[j+1];
                x[j+1] = temp;
              end
          end
      end 

    $display("--- Despliegue los resultados ---");

    //Despliegue los resultados
    for (i=0; i<16; i=i+1)
      begin
        $display("%d", x[i]);
      end
  end
endmodule
