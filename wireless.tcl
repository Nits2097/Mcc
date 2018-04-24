set val(chan)	Channel/WirelessChannel;
set val(prop)	Propagation/TwoRayGround;
set val(netif)	Phy/WirelessPhy;
set val(m)		Mac/802_11;
set val(ifq)	Queue/DropTail/PriQueue;
set val(ll)		LL;
set val(ant)	Antenna/OmniAntenna;
set val(ifqlen)	50;
set val(nn)		5;
set val(rp)		AODV;

set ns_ [new Simulator]
set tracefd [open simple.tr w]
$ns_ trace-all $tracefd 

set namtr [open out.nam w]
$ns_ namtrace-all-wireless $namtr 500 500

set topo [new Topogaphy]
$topo load_flatgrid 500 500

create-god $val(nn)

#configure node

$ns_ node-config -AdhocRouting $val(rp) \
	-llType $val(ll) \
	-macType $val(mac)	\
	-phyType $val(phy)	\
	-chanType $val(chan)	\
	-propType $val(prop)	\
	-ifqType $val(ifq)	\
	-ifqLen $val(ifqlen)	\
	-antType $val(ant)	\
	-topoInstance $topo \
	-agentTrace OFF \
	-routerTrace ON \
	-movementTrace OFF \
	-macTrace OFF

	for {set i 0} {$i < $val(nn)} {incr i} {
		set node_($i) [$ns_ node]
		$node_($i) random-motion 0	; 
	}

$node_(0) set X_ 50.0
$node_(0) set Y_ 20.0

$ns_ at 10.0 "$node_(0) setdest 20.0 24.0 15.0"

set tcp [new Agent/TCP]
$tcp set class_ 2
set sink [new Agent/TCPSink]
$ns_ attach-agent $node_(0) $tcp


proc stop {} {
	global ns_ tracefd
	$ns_ flush-trace
	close $tracefd
}


