module Sequencia (
    input wire clk,
    input wire rst_n,

    input wire setar_palavra,
    input wire [7:0] palavra,

    input wire start,
    input wire bit_in,

    output reg encontrado
);

	// Registrador para armazenar a palavra a ser buscada
	reg [7:0] palavra_reg;
	
	// Registrador de deslocamento para armazenar os últimos 8 bits recebidos
	reg [7:0] shift_reg;
	
	// Estado interno para saber se estamos processando a sequência
	reg processando;
	
	always @(posedge clk or negedge rst_n) begin
	    if (!rst_n) begin
	        // Reset assíncrono (ativo baixo)
	        palavra_reg = 8'b0;
	        shift_reg = 8'b0;
	        encontrado = 1'b0;
	        processando = 1'b0;
	    end else begin
	        if (setar_palavra) begin
	            // Armazenar nova palavra
	            palavra_reg <= palavra;
	        end
	
	        if (start) begin
	            // Começar a processar
	            processando = 1'b1;
	            encontrado = 1'b0;
	            shift_reg = 8'b0; // Limpa o shift_reg no início
	        end
	
	        if (processando && !encontrado) begin
	            // Recebendo e deslocando os bits
	            shift_reg = {shift_reg[6:0], bit_in};
	
	            // Comparar registrador de deslocamento com palavra
	            if (shift_reg == palavra_reg) begin
	                encontrado = 1'b1;
	                processando = 1'b0; // Opcional: para parar depois de encontrar
	            end
	        end
	    end
	end
endmodule
