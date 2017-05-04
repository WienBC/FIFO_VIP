class fifo_drvr_monitor extends uvm_monitor;
  
  `uvm_component_utils(fifo_drvr_monitor)

  uvm_analysis_port #(fifo_seq_item)  drvr_ap;

  virtual fifoif#(`WIDTH, `DEPTH)     fifo_if; 

  fifo_seq_item                       seq_item_h;
  
  function new( string name, uvm_component parent);
    super.new(name, parent);
	drvr_ap = new("drvr_ap", this);
  endfunction 

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
	if(!uvm_config_db #(virtual fifoif #(`WIDTH, `DEPTH))::get(this, "", "fifo_if", fifo_if)) begin 
	  `uvm_fatal("DRVR_MONITOR", "Interface not set?")
	end 
  endfunction 

  task run_phase(uvm_phase phase);
    seq_item_h = fifo_seq_item::type_id::create("seq_item_h", this);
	forever begin 
	  collect_data();
	end 
  endtask

  task collect_data(); 
    @(negedge fifo_if.clk);
	if(!fifo_if.rst) begin
	  seq_item_h.pull     = fifo_if.pull;
	  seq_item_h.push     = fifo_if.push ;
	  seq_item_h.datain   = fifo_if.datain ;
	  seq_item_h.full     = fifo_if.full;
	  seq_item_h.empty    = fifo_if.empty;

	  drvr_ap.write(seq_item_h);
	end
  endtask 

endclass 
