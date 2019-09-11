unit stepBar;

interface

uses
  System.UITypes, System.Classes, FMX.Types, FMX.Objects, Radiant.Shapes, math,
  FMX.imglist,system.types;

type

  tStepBar = class(tObject)
  private
    fOwner            : tComponent;
    fParent           : tFmxObject;
    fSteps,
    fProgress         : byte;
    fcircleSize       : single;
    outerRect,
    innerRect,
    progressRect      : TRadiantRectangle;

    fstepBaseColor,
    fstepFilledColor,
    fOuterRectColor,
    fInnerRectColor,
    fProgressColor    : tColor;
    circles           : array of tRadiantCircle;
   // images            : array of tglyph;

    procedure updateProgressDisplay;
    procedure setProgress(newProgress:byte);
    procedure setSteps(newStepCount:byte);
    procedure setCircleSize(newSize:single);
    procedure setStepFilledColor(newColor:tColor);
    procedure setStepBaseColor(newColor:tColor);
    procedure setOuterRectColor(newColor:tColor);
    procedure setInnerRectColor(newColor:tColor);
    procedure setProgressColor(newColor:tColor);

  public
    property stepFilledColor : tColor      read fStepFilledColor  write setStepFilledColor;
    property stepBsseColor   : tColor      read fstepBaseColor    write setStepBaseColor;
    property outerRectColor  : tColor      read fOuterRectColor   write setOuterRectColor;
    property innerRectColor  : tColor      read fInnerRectColor   write setInnerRectColor;
    property progressColor   : tColor      read fProgressColor    write setProgressColor;
    property circleSize      : single      read fcircleSize       write setCircleSize;
    property owner           : tComponent  read fOwner            write fOwner;
    property parent          : tFmxObject  read fParent           write fParent;
    property Progress        : byte        read fProgress         write setProgress;
    property steps           : byte        read fSteps            write setSteps;

    procedure setStepImage(aStepNumber:byte;anImage:tGlyph);
    constructor create(aOwner:tComponent);
  end;

implementation

procedure tStepBar.setStepFilledColor(newColor:tColor);
begin
  fStepfilledColor:=newColor;
  updateProgressDisplay;
end;

procedure tStepBar.setStepBaseColor(newColor:tColor);
begin
  fStepBaseColor:=newColor;
  updateProgressDisplay;
end;

procedure tStepBar.setProgressColor(newColor:tColor);
begin
  fProgressColor:=newColor;
  updateProgressDisplay;
end;

procedure tStepBar.setOuterRectColor(newColor:tColor);
begin
  fOuterRectColor:=newColor;
  updateProgressDisplay;
end;

procedure tStepBar.setInnerRectColor(newColor:tColor);
begin
  fInnerRectColor:=newColor;
  updateProgressDisplay;
end;

procedure tStepBar.setStepImage(aStepNumber: Byte; anImage: TGlyph);
var aCircle : tRadiantCircle;
begin
  if aStepNumber>fSteps then
    exit;
   aCircle:=circles[aStepNumber];
   anImage.Parent:=aCircle;
   anImage.Align:=tAlignLayout.Center;
end;

procedure tStepBar.updateProgressDisplay;
var i : integer;
    aCircle : tRadiantCircle;
    spaceBetweenCircles : single;
begin
  progressRect.Width:=0;
  if fsteps<1 then
        exit;

  (* update fill color for rectangles *)
  outerRect.Fill.Color:=outerRectColor;
  innerRect.Fill.Color:=innerRectColor;
  progressRect.Fill.Color:=progressColor;

  (* calculate space between step circles *)
  spaceBetweenCircles:=(outerRect.Width-(fsteps*fCircleSize))/fsteps;

  (* Update and draw inner step circles *)
  for i := 0 to fsteps-2 do
  begin
    aCircle:=circles[i];
    aCircle.Position.Y:=(OuterRect.Height/2)-(aCircle.Height/2);
    aCircle.Position.X:=(spaceBetweenCircles*(i+1)+(fCircleSize*i));
    aCircle.Size.Width:=fCircleSize;
    aCircle.Size.Height:=fCircleSize;
    aCircle.Fill.Color:=fStepBaseColor;
    if i<fprogress then
      aCircle.Fill.Color:=fstepFilledColor
  end;

  (* update and draw last step circle *)
  aCircle:=circles[fsteps-1];
  aCircle.Width:=fCircleSize;
  aCircle.Size.Height:=fCircleSize;
  aCircle.Position.Y:=(OuterRect.Height/2)-(aCircle.Height/2);
  aCircle.Position.X:=outerRect.Width-(fCircleSize/2);

  (* if last step has been completed set fill color accordingly *)
  if (fprogress=fsteps) then
     aCircle.Fill.Color:=fstepFilledColor
  else
    aCircle.Fill.Color:=fStepBaseColor;

  (* if steps have been completed, set progress bar to completed step*)
  if fProgress>0 then
    progressRect.Width:=circles[fprogress-1].Position.X+(circleSize/2);
end;


procedure tStepBar.setCircleSize(newSize: Single);
begin
  fCircleSize:=newSize;
  updateProgressDisplay;
end;

(* set the number of steps in the step bar *)
procedure tStepBar.setSteps(newStepCount: Byte);
var i : byte;
    aCircle : tRadiantCircle;
    anImage : tGlyph;
begin
  if newStepCount=fSteps then
    exit;

  if newStepCount>fSteps then
  begin
    for i := fSteps to newStepCount-1 do
    begin
      aCircle:=tRadiantCircle.Create(outerRect);
      aCircle.Parent:=outerRect;
      aCircle.Width:=fCircleSize;
      aCircle.Position.Y:=(OuterRect.Height/2)-(aCircle.Height/2);
      aCircle.Position.X:=outerRect.Width-(fCircleSize/2);
      setLength(circles,i+1);
      circles[i]:=aCircle;
    end;
  end
  else
  begin
    for i:=newStepCount to fsteps-1 do
    begin
      aCircle:=circles[i];
      aCircle.Destroy;
    end;
    setLength(circles,newStepCount);
  end;
  fSteps:=newStepCount;
  updateProgressDisplay;
end;

procedure tStepBar.setProgress(newProgress: Byte);
begin
  if (newProgress<=fSteps) and (newProgress>=0) then
  begin
    fProgress:=newProgress;
    updateProgressDisplay;
  end;
end;

constructor tStepBar.create(aOwner: TComponent);
begin
  inherited create;
  owner:=aOwner;
  parent:=tFMXObject(owner);
  fsteps:=0;

  fCircleSize:=50;
  fprogress:=0;
  fStepBaseColor:=$FFE0E0E0;
  finnerRectColor:=$FFBADAD0;
  fOuterRectColor:=$FF2C343F;
  fprogressColor:=$FF46B692;
  fStepFilledColor:=$FF46B692;

  outerRect:=tRadiantRectangle.Create(owner);
  outerRect.Parent:=parent;
  outerRect.Align:=TAlignLayout.Client;

  innerRect:=tRadiantRectangle.Create(owner);
  innerRect.Parent:=outerRect;
  innerRect.Align:=TAlignLayout.Center;

  innerRect.Size.Height:=outerRect.Size.Height-2;
  innerRect.Size.Width:=outerRect.Size.Width-2;

  progressRect:=tRadiantRectangle.Create(owner);
  progressRect.Parent:=innerRect;
  progressRect.Align:=TAlignLayout.Left;
  progressRect.Size.Height:=outerRect.Size.Height-2;
  updateProgressDisplay;
end;


end.
