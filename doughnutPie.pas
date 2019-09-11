unit DoughnutPie;

interface

uses
  System.UITypes, System.Classes, FMX.Types, FMX.Objects, Radiant.Shapes, math,
  FMX.imglist;
type
  tDonoughtSector = record
    sector : tRadiantSector;
    value  : single;
  end;

type
  tDoughnutPie = class(TObject)
    fimage       : tGlyph;
    imageCircle  : tRadiantCircle;
    innerCircle  : tRadiantCircle;
    sectors      : array of tDonoughtSector;
    fthickness   : integer;
    fPieSize        : integer;
    ftotal       : single;
    sectorCount  : byte;
    parent       : tFmxObject;
    owner        : tComponent;
    private
    procedure updatePieDisplay;
    procedure setThickness(aValue:integer);
    procedure setSize(aValue:integer);
    procedure setImage(anImage:tGlyph);
  public
    property thickness     : integer  read fthickness write setThickness;
    property pieSize       : integer  read fPieSize   write setSize;
    property image         : tGlyph   write setimage;
    constructor create(aOwner:TComponent);
    procedure addSector(color : tColor; sectorValue:single);
    procedure updateSector(aSectorNumber:byte;newValue:single);
    procedure setSectorColor(aSectorNumber:byte;aColor:tColor);
  end;

implementation

(* Set an image for the center of the doughnut*)
procedure tDoughnutPie.setImage(anImage: tGlyph);
begin
  fImage:=anImage;
  fImage.Parent:=imageCircle;
  fImage.Align:=tAlignLayout.Center;
  updatePieDisplay;
end;

(* Update pie display *)
procedure tDoughnutPie.updatePieDisplay;
var  i       : integer;
     lastPos : single;
     pieUnit : single;
begin

  innerCircle.BringToFront;
  imageCircle.BringToFront;
  (* if an image has been assigned bring it to front*)
  if fimage<>nil then
    fimage.BringToFront;

  (* set thicknes for inner circle *)
  innerCircle.Width:=fPieSize-fThickness;
  innerCircle.Height:=fPieSize-fThickness;

  (* Calculate and draw the circles *)
  if sectorCount>0 then
  begin
    pieUnit:=360/fTotal;
    sectors[0].sector.height:=fPieSize;
    sectors[0].sector.width:=fPieSize;
    sectors[0].sector.startAngle:=0;
    sectors[0].sector.centralAngle:=pieUnit*sectors[0].value;
    lastPos:=sectors[0].sector.centralAngle;

    for i := 1 to sectorCount-1 do
    begin
      sectors[i].sector.height:=fPieSize;
      sectors[i].sector.width:=fPieSize;
      sectors[i].sector.StartAngle:=lastPos;
      sectors[i].sector.CentralAngle:=pieUnit*sectors[i].value;
      lastPos:=lastPos+sectors[i].sector.CentralAngle;
    end;
  end;
end;


(* set Pie thickness *)
procedure tDoughnutPie.setThickness(aValue: Integer);
begin
  fThickness:=aValue;
  updatePieDisplay;
end;

(* Set total Pie Size *)
procedure tDoughnutPie.setSize(aValue: Integer);
begin
  fPieSize:=aValue;
  updatePieDisplay;
end;

(* Set color of a pie section *)
procedure tDoughnutPie.setSectorColor(aSectorNumber: Byte; aColor: TColor);
begin
  if sectorCount>aSectorNumber then
    sectors[aSectorNumber].sector.Fill.Color:=aColor;
end;

(* update sector value *)
procedure tDoughnutPie.updateSector(aSectorNumber: Byte; newValue: single);
var i : byte;
begin
  fTotal:=0;
  if sectorCount>aSectorNumber then
  begin
    for i := 0 to sectorCount-1 do
      fTotal:=fTotal+sectors[i].value;
    sectors[aSectorNumber].value:=newValue;
    updatePieDisplay;
  end;
end;


(* add a pie section *)
procedure tDoughnutPie.addSector(color: TColor; sectorValue: single);
var aRadiantSector : tRadiantSector;
begin
  inc(SectorCount);
  setlength(sectors,sectorCount);
  aRadiantSector:=tRadiantSector.Create(owner);
  aRadiantSector.Parent:=parent;
  aRadiantSector.Align:=TAlignLayout.Center;
  aRadiantSector.Height:=500;
  aRadiantSector.Width:=500;
  aRadiantSector.RotationAngle:=-90;
  aRadiantSector.Stroke.Thickness:=0;
  aRadiantSector.CentralAngle:=0;
  aRadiantSector.Fill.Color:=color;
  sectors[sectorCount-1].sector:=aRadiantSector;
  sectors[sectorCount-1].value:=sectorValue;

  fTotal:=fTotal+sectorValue;
  updatePieDisplay;
end;


(* Create and initialize a doughnut Pie*)
constructor tDoughnutPie.create(aOwner: TComponent);
begin
  inherited create;
  sectorCount:=0;
  ftotal:=0;
  fPieSize:=350;
  fThickness:=100;
  owner:=aOwner;
  parent:=tFmxObject(owner);

  innerCircle:=tRadiantCircle.Create(owner);
  innerCircle.Parent:=parent;
  innerCircle.Align:=TAlignLayout.Center;

  innerCircle.Width:=fPieSize-fThickness;
  innerCircle.Height:=fPieSize-fThickness;

  imageCircle:=tRadiantCircle.Create(owner);
  imageCircle.Parent:=parent;
  imageCircle.Align:=TAlignLayout.Center;
  updatePieDisplay;
end;

end.
