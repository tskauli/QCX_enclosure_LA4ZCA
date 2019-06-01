/*

           ***  QCX Transceive cabinet with integrated battery and paddles  **
           
                        January 2019, LA4ZCA, tskauli@gmail.com

TODO: Spacer and recess built-in to bring buttons flush with front

*/

// Control of rendering
part=1;             // 1=main cabinet, 2=lid, 4 knob preview, 5=all
cacc=4;             // multiplier for circle segment count. =1 for draft, =4 for final
attachPaddle=true;  // Whether to include attachment for paddle
fit_test=false;     // whether to print with large openings to check fit

gap=0.2;            // size of a small gap that can be produced by printer
nil=0.001;          // negligible size, to fix rendering where needed

// Battery
wxbatt=78;          // battery x width (Tattu LiPo 4S 1300mAh ex cable)
hybatt=47;          // battery y width incl cable
dzbatt=28;          // battery z height

// QCX 
inch=25.4;
wxQCX=4.0*inch+1;   // width and height of QCX board. 1 mm extra for mounting ease
hyQCX=3.2*inch+1;   // 1mm extra for heat sink
dzPCB=4;            // total thickness of PCB incl. back solderings
dispcenx=0.4252*inch+80/2;// Display center relative to board origin
dispedgy=1.7827*inch;
dispceny=hyQCX-20.5;
wxdisp=64.5+1;      // Dimensions of the actual display, with margin
hydisp=14.5+1;
zboard=26.5;        // height from main PCB top to display top (with 5mm extra spacers)
dxBNC=2.7;          // bnc inner thread end outside board edge
dyBNC=2.35*inch;    // BNC y position rel to board front edge
dzBNC=6;            // BNC z offset below board
diaBNC=12.5;        // Dia. of threaded part of BNC
dyconn=20;          // y width of connector part of side panel

diaPhones=6.3;      // Dia. of phone jack panel hole
dzPhones=8;         // total height of phone jack
spkrdx=40;          // Speaker dimensions
spkrdy=28;
GPSdx=25;           // GPS dimensions
GPSdy=25;

// Outer shape of bottom lid
snapsepar=20;
snaplength=10;
snapradius=1.5;
snapheight=0.75;

// Other cabinet properties
thwall=1.5;         // wall thickness of box (NOTE: Must match thickness of paddle attachment, if used)
gripdia=20;
wdove=5;            // total width of dovetail
dzlid=thwall+2;     // back lid recess depth
lidrim=0.7;         // width of lid rim
volx=17;            // distance of volume and on/off switch from edge
swdx=15;            // distance between left and right switch
swdy=20;            // y distance from volume to switch
dyknobs=9;          // distance of knob axes from inner wall

// Paddle attachment
use <QCXcabinetPaddleAttach.scad> // defines QCXpaddleHeight, QCXpaddleAttachment() and QCXpaddleStopper()
module QCXpaddleAttachmentLOCAL(){
    QCXpaddleAttachment();
};
borgx=thwall+gap;   // board origin x, y
borgy=hybatt+2*thwall+gap;
wxinner=wxQCX+2*gap;// make loose fit for card in cabinet
hyinner=hyQCX+2*gap;
dzinner=max(dzbatt+dzlid,zboard+dzPCB);        // inner depth
QCXzheight=dzinner+thwall;
QCXxwidth=wxinner+2*thwall;
QCXywidth=hybatt+3*thwall+hyinner;
echo("Box inner height incl. lid thickness (mm):",dzinner);
echo("QCX cabinet total z height=",QCXzheight);
echo("QCX cabinet total x width=",QCXxwidth);
echo("QCX cabinet total y length=",QCXywidth);
echo("Paddle width to make outer square shape:",QCXywidth-QCXxwidth);
holexyd=[           // x, y, diam. of holes for controls in front panel (and dia of knob, approx)
    [volx,borgy+dyknobs,8,20],                  // switch
    [(wxinner+2*thwall)/2,borgy+dyknobs,7,35],  // encoder
    [wxinner+2*thwall-volx,borgy+dyknobs,7,20], // volume
    [wxinner+2*thwall-volx-swdx/2,borgy+dyknobs+swdy,6.5,5], // right switch
    [wxinner+2*thwall-volx+swdx/2,borgy+dyknobs+swdy,6.5,5]  // left switch
    ];

module snap(snapl){ // bumps to snap box together
// snapl is length of bump, passed as parameter to allow tolerance
difference(){
    translate([snapradius-snapheight,-snapl/2,0])
    rotate([-90,0,0])
        cylinder(h=snapl,r=snapradius,$fn=20);
    translate([nil,-snapl/2,-snapradius])
        cube([2*snapradius,snapl,2*snapradius]);
};
}; // end snap
module lid(snaplen,recess=true){
    difference(){
        // outer lid shape
        cube([wxinner,hyinner+thwall+hybatt,dzlid]);
        //dovetail space
//        cube([wdove-thwall,hybatt,dzlid]);
        
        //finger grip
        translate([0,thwall+hybatt/2,0]){
            cube([gripdia/2,gripdia,2*dzlid],center=true);
            translate([gripdia/4,0,0])
            cylinder(d=gripdia,h=dzlid);
        };
        
        // inner lid recess
        if (recess){
            // recess over battery
            translate([lidrim+gripdia/*+wdove*/,lidrim,-thwall])
            cube([wxinner-2*lidrim-gripdia/*-wdove*/,hybatt-2*lidrim,dzlid]);
            // recess over PCB
            translate([lidrim,lidrim+hybatt+thwall,-thwall])
            cube([wxinner-2*lidrim,hyinner-2*lidrim,dzlid]);
        };
    };
    
    // edge snaps
    translate([0,      hybatt+2*thwall+25,        dzlid/2])snap(snaplen);
    translate([0,      hybatt+2*thwall+hyinner-25,dzlid/2])snap(snaplen);

    translate([wxinner,hybatt+2*thwall+25,        dzlid/2])rotate([0,0,180])snap(snaplen);
    translate([wxinner,hybatt+2*thwall+hyinner-25,dzlid/2])rotate([0,0,180])snap(snaplen);
    translate([wxinner,thwall+hybatt/2,dzlid/2])rotate([0,0,180])snap(snaplen);

    translate([thwall+25,hybatt+thwall+hyinner,dzlid/2])rotate([0,0,-90])snap(snaplen);
    translate([thwall+wxinner-25,hybatt+thwall+hyinner,dzlid/2])rotate([0,0,-90])snap(snaplen);

    translate([thwall+25        ,0,dzlid/2])rotate([0,0,90])snap(snaplen);
    translate([thwall+wxinner-25,0,dzlid/2])rotate([0,0,90])snap(snaplen);
};
module teardropHole(lh,rh){ // Hole with 45-degree teardrop shape
    rotate([90,0,0])
    rotate([0,0,45])
    union(){
        cylinder(h=lh,r1=rh,r2=rh,$fn=8*cacc);
        cube([rh,rh,lh]);
    };
};
module wedge(a,wx,hz){ // Equilateral triangular block
   //top angle a(deg), length hz and triangle height wx in x direction
    linear_extrude(height=hz)
    polygon([[0,0],[wx,wx*tan(a/2)],[wx,-wx*tan(a/2)]]);
};
// box defined by inner dimensions and wall thickness
// gaprel is fraction of gap in side walls
module box(wxin,hyin,dzin,thw,gaprel=0){
    translate([-thw-wxin/2,-thw-hyin/2,0])
    difference(){
        cube([wxin+2*thw,hyin+2*thw,dzin+thw]);
        translate([thw,thw,thw])
        cube([wxin,hyin,dzin]);
        if(gap>0){
            translate([0,(hyin*(1-gaprel))/2+thw,thw])
            cube([wxin+2*thw,hyin*gaprel,dzin]);
            translate([(wxin*(1-gaprel))/2+thw,0,thw])
            cube([wxin*gaprel,hyin+2*thw,dzin]);
        };
    };
};
// chamfered box given by inner dimensions and wall thickness (=2xchamfer)
module chamferbox(wxin,hyin,dzin,thw){
    hull()
        for (ix=[thw/2,wxin-thw/2])
        for(iy=[thw/2,hyin-thw/2])
        for (iz=[thw/2,dzin-thwall/2])
        translate([ix,iy,iz])
        // Diamond shape to define chamfer and corners
        union(){
            cylinder(r1=thwall/2,r2=0,h=thwall/2,$fn=4);
            rotate([180,0,0])
            cylinder(r1=thwall/2,r2=0,h=thwall/2,$fn=4);
        };
    };
module tube(do,di,ht){       // tube with outer diameter do, inner diameter di and length ht
    difference(){
        cylinder(d=do,h=ht,$fn=8*cacc);
        cylinder(d=di,h=ht,$fn=8*cacc);
    };
};
module basebox(){
    difference(){
        
        union(){
           // outer box shape
           chamferbox(wxinner+2*thwall,hyinner+hybatt+3*thwall,dzinner+thwall,thwall);

            // Widening for BNC connector
            dyw=dyconn+2*thwall;
            translate([-dxBNC-gap,hybatt+2*thwall+gap+dyBNC-dyw/2,0])
            chamferbox(wxinner+2*thwall,dyw,dzinner+thwall,thwall);
            
            // Rotation stopper for attached paddle
            if (attachPaddle){
                translate([0,0,QCXzheight-QCXpaddleHeight()])
                mirror([0,1,0])
                mirror([0,0,1])
                QCXpaddleStopper();
            }
        };

        // room for electronics
        translate([thwall,hybatt+2*thwall,thwall])
        cube([wxinner,hyinner,dzinner]);
            
        // battery compartment
        translate([thwall,thwall,thwall])
        cube([wxinner,hybatt,dzinner]);

        // extra room for BNC and headphone connectors
        translate([thwall-dxBNC,hybatt+2*thwall+dyBNC-dyconn/2,thwall])
        cube([dxBNC+nil,dyconn,dzinner]);

        // phones hole
        translate([0,hybatt+2*thwall+dyBNC,thwall+dzPhones/2])
        rotate([0,0,-90])teardropHole(10,diaPhones/2);
        
        // internal wiring holes
        translate([wxinner/6+thwall,hybatt,dzinner-7])
        rotate([0,0,180])teardropHole(10,4);
        translate([5*wxinner/6+thwall,hybatt,dzinner-7])
        rotate([0,0,180])teardropHole(10,4);
        
        // internal wiring fastener holes
        translate([wxinner/6+thwall,hybatt,dzinner-15])
        rotate([0,0,180])teardropHole(10,2);
        translate([5*wxinner/6+thwall,hybatt,dzinner-15])
        rotate([0,0,180])teardropHole(10,2);
        
        // Room for attached paddle
        if (attachPaddle){
            translate([0,0,QCXzheight-QCXpaddleHeight()])
            mirror([0,1,0])
            mirror([0,0,1])
            hull(){QCXpaddleAttachment();};
        }
    };
    
    // Speaker rim
    translate([borgx+dispcenx,borgy+dispedgy-spkrdy/2,0])
    box(spkrdx,spkrdy,3,thwall,gaprel=0.75);

    // GPS rim (lifted to not disturb outer chamfer)
    translate([GPSdx/2+thwall+2+1.5,borgy+dispedgy-GPSdy/2,thwall/2])
    box(GPSdx,GPSdy,3-thwall/2,thwall/2,gaprel=0.6);
    
    // board supports
    translate([thwall,2*thwall+hybatt,thwall])
    cube([5,5,zboard]);
    translate([thwall+wxinner-5,2*thwall+hybatt,thwall])
    cube([5,5,zboard]);
    
    // extra material above connectors
    translate([thwall-dxBNC,hybatt+2*thwall+dyBNC-dyconn/2,dzinner])
    cube([dxBNC+nil,dyconn,thwall]);

    // 45 deg underside of extra material, to avoid generation of support
    translate([thwall-dxBNC,hybatt+2*thwall+dyBNC-dyconn/2,dzinner])
    rotate([-90,45,0])
    wedge(90,dxBNC/sqrt(2),dyconn);
    
    // lid supports
    translate([thwall+5/*wdove*/,thwall,thwall])
    cube([5,lidrim*1.5/*wdove/2*/,dzinner-dzlid]);
    translate([thwall+wxinner-5,thwall,thwall])
    cube([5,lidrim*1.5,dzinner-dzlid]);
    
};
module main_cabinet(){
difference(){
    union(){
        basebox();

        // Attachment for paddle
        if (attachPaddle){
            translate([0,0,QCXzheight-QCXpaddleHeight()])
            mirror([0,1,0])
            mirror([0,0,1])
            QCXpaddleAttachment();
        }
        
        // Battery stopper
        translate([thwall+wxinner-wxbatt-2*thwall,hybatt/4,thwall])
            cube([2*thwall,hybatt/2,6]);
    };
    
    // lid recess, with extra length of snaps to keep ends from colliding
    translate([thwall,thwall,thwall+dzinner-dzlid+nil])
    lid(snaplength+1,false);
        
    // Front panel holes
    for(ih=[0:len(holexyd)-1])
    translate([holexyd[ih][0],holexyd[ih][1],0])
    cylinder(h=thwall,d=holexyd[ih][2],$fn=8*cacc);
    
    // Opening for display
    translate([hydisp/2-wxdisp/2+borgx+dispcenx,borgy+dispceny,0])
    hull(){
        rotate([0,0,45])
        cylinder(r1=sqrt(2)*(hydisp/2+thwall),r2=sqrt(2)*hydisp/2,h=thwall,$fn=4);
        translate([wxdisp-hydisp,0,0])
        rotate([0,0,45])
        cylinder(r1=sqrt(2)*(hydisp/2+thwall),r2=sqrt(2)*hydisp/2,h=thwall,$fn=4);
    };
    
    // speaker holes, adjusted a little upwards
    translate([borgx+dispcenx,borgy+dispedgy-spkrdy/2+5,0])
    {
       cylinder(d=2,h=thwall,$fn=5*cacc);
       for (a=[0:45:360]){
            translate([4.5*sin(a),4.5*cos(a),0])
            cylinder(d=2,h=thwall,$fn=5*cacc);
            };
        for (a=[15:30:360]){
            translate([8*sin(a),8*cos(a),0])
            cylinder(d=2,h=thwall,$fn=5*cacc);
            };
    }

    // BNC hole
    translate([dyBNC,hybatt+2*thwall+dyBNC,thwall+zboard-dzBNC])
    rotate([0,0,-90])teardropHole(100,diaBNC/2);

    if(fit_test){
        
        // battery compartment
        translate([0,3*thwall,3*thwall])
        cube([100+wxinner+thwall,hybatt-6*thwall,dzinner]);

        // room for electronics
        translate([0,hybatt+5*thwall,3*thwall])
        cube([100+wxinner,hyinner-6*thwall,dzinner]);
        translate([3*thwall,hybatt+2*thwall,3*thwall])
        cube([wxinner-6*thwall,100+hyinner,dzinner]);
    };

    
};
};

if (part==1) main_cabinet();
if (part==2) rotate([180,0,0])lid(snaplength);
if (part==3) translate([0,0,dzinner+thwall])
             rotate([180,0,0])
             batteryDoor();

if (part==4) {
    main_cabinet();
    // Dummy buttons
    for(ih=[0:len(holexyd)-1])
    translate([holexyd[ih][0],holexyd[ih][1],0])
    rotate([180,0,0])
    cylinder(h=10,d=holexyd[ih][3]);
}
if (part==5){
    main_cabinet();
    translate([thwall,thwall,dzinner-dzlid+thwall+10])
    rotate([0,0,0])
    lid(snaplength);
    rotate([0,0,0])
    translate([0,0,1])batteryDoor();
};
