"""Render the English architecture figure. Requires Matplotlib; no project RTL is changed."""
from pathlib import Path
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
from matplotlib.patches import FancyBboxPatch, FancyArrowPatch

OUT = Path(__file__).resolve().parents[1] / 'docs' / 'images'
OUT.mkdir(parents=True, exist_ok=True)
plt.rcParams.update({'font.family':'DejaVu Sans','svg.fonttype':'none','svg.hashsalt':'fpga-camera-v1'})
fig, ax = plt.subplots(figsize=(16,10.8), dpi=150)
fig.patch.set_facecolor('#ffffff')
ax.set_xlim(0,1600);ax.set_ylim(1080,0);ax.axis('off')
fig.subplots_adjust(0,0,1,1)
NAVY='#13263e';BLUE='#2563b8';TEAL='#087e80';GRAY='#53657b';BORDER='#c8d5e4'

def txt(x,y,s,size=13,color=NAVY,weight='normal',ha='left'):
    ax.text(x,y,s,fontsize=size,color=color,fontweight=weight,ha=ha,va='center')

def rect(x,y,w,h,fill='#ffffff',edge=BORDER,r=10,lw=1.25):
    ax.add_patch(FancyBboxPatch((x,y),w,h,boxstyle=f'round,pad=0,rounding_size={r}',facecolor=fill,edgecolor=edge,linewidth=lw))

def box(x,y,w,h,title,lines,number=None,fill='#ffffff',edge=BORDER):
    rect(x,y,w,h,fill,edge)
    if number:
        rect(x+14,y+15,29,27,'#e7effb','#e7effb',r=6,lw=0)
        txt(x+28.5,y+29,number,10,BLUE,'bold','center')
    txt(x+(56 if number else 18),y+29,title,14,NAVY,'bold')
    for j,line in enumerate(lines):txt(x+18,y+62+23*j,line,11.3,GRAY)

def arrow(points,color=BLUE,dashed=False,both=False,lw=2):
    for a,b in zip(points[:-2],points[1:-1]):
        ax.plot([a[0],b[0]],[a[1],b[1]],color=color,lw=lw,linestyle=(0,(4,3)) if dashed else '-')
    a,b=points[-2:]
    ax.add_patch(FancyArrowPatch(a,b,arrowstyle='<->' if both else '-|>',mutation_scale=14,linewidth=lw,color=color,linestyle=(0,(4,3)) if dashed else '-'))

txt(42,43,'FPGA CAMERA-TO-LCD',12,BLUE,'bold')
txt(42,86,'Image Processing Architecture',28,NAVY,'bold')
txt(42,126,'RGB565 frame buffering, fixed-point color conversion, and luminance enhancement',13,GRAY)

# Main hardware area, with off-chip devices kept outside the FPGA boundary.
rect(222,168,1336,672,'#f7faff','#d5dfec',r=16)
txt(244,192,'FPGA  /  top.v',12,BLUE,'bold')
box(32,269,159,135,'Camera',['8-bit pixel bus','HSYNC / VSYNC','Pixel clock'],fill='#edf3fa')
box(250,258,275,155,'Camera capture',['CIS_IF','8-bit input → RGB565','17-bit pixel address'],'01')
box(585,258,255,155,'Pixel packing',['packing','2 × 16-bit pixels','→ 1 × 32-bit word'],'02')
box(900,258,265,155,'Frame buffer',['bufferram  (external IP)','Target: 65,536 × 32 bits','16-bit word address'],'03')
box(1225,258,300,155,'Pixel unpacking',['Unpacking','32-bit word → RGB565','Read-address sequencing'],'04')

arrow([(191,336),(250,336)]);txt(220,320,'8b',10,BLUE,ha='center')
arrow([(525,336),(585,336)]);txt(555,320,'16b',10,BLUE,ha='center')
arrow([(840,336),(900,336)]);txt(870,320,'32b',10,BLUE,ha='center')
arrow([(1165,336),(1225,336)]);txt(1195,320,'32b',10,BLUE,ha='center')

box(1225,493,300,155,'RGB565 → YCbCr',['RGB_to_YCbCr  /  R_2_Y.v','6 fractional coefficient bits','24-bit Y / Cb / Cr'],'05')
box(900,493,265,155,'Two-line buffer',['process  /  filtering.v','48-bit stored line pairs','72-bit vertical pixel stack'],'06')
box(585,493,255,155,'Luma enhancement',['conv','3 × 3 neighborhood','Laplacian + gain + clipping'],'07')
box(250,493,275,155,'YCbCr → RGB565',['YCbCr_to_RGB  /  Y_2_R.v','Output via BRAMCtrl','R: 5b  ·  G: 6b  ·  B: 5b'],'08')
box(32,503,159,135,'TFT LCD',['480 × 272 pixels','RGB565 display','HSYNC / VSYNC'],fill='#edf3fa')
arrow([(1375,413),(1375,493)]);txt(1391,453,'16b',10,BLUE)
arrow([(1225,570),(1165,570)]);txt(1195,554,'24b',10,BLUE,ha='center')
arrow([(900,570),(840,570)]);txt(870,554,'72b',10,BLUE,ha='center')
arrow([(585,570),(525,570)]);txt(555,554,'24b',10,BLUE,ha='center')
arrow([(250,570),(191,570)]);txt(220,554,'16b',10,BLUE,ha='center')

# Control paths are deliberately abstracted from the pixel-data path.
box(250,713,275,101,'Camera configuration',['Reused I²C controller','i2c_top + i2cset + I2C'],fill='#ecf8f6',edge='#9ac9c3')
ax.plot([250,210,210],[764,764,592],color=TEAL,lw=2,linestyle=(0,(4,3)))
arrow([(210,546),(210,443),(111,443),(111,404)],TEAL,True)
txt(119,460,'I²C control',10,TEAL)
box(585,713,940,101,'Display timing & memory-address control',['TFTLCDCtrl  ·  g2m  ·  horizontal  ·  vertical  ·  BRAMCtrl','Pixel timing, line/frame sync, processing enable, and read-address generation'],fill='#ecf8f6',edge='#9ac9c3')
arrow([(710,713),(710,648)],TEAL,True)
arrow([(1033,713),(1033,648)],TEAL,True)
arrow([(1460,713),(1460,687),(1540,687),(1540,236),(1375,236),(1375,258)],TEAL,True)
txt(1220,680,'Control / read address',10,TEAL)
arrow([(585,795),(550,795),(550,860),(110,860),(110,638)],TEAL,True)
txt(118,833,'LCD timing',10,TEAL)

# Offline work is presented as the design process, never as a runtime stage.
rect(32,895,1526,110,'#f4f5f8','#dfe4eb',r=12)
txt(54,918,'DEVELOPMENT FLOW  /  OFFLINE',10,GRAY,'bold')
txt(54,959,'C & MATLAB prototypes',14,NAVY,'bold')
txt(54,985,'Algorithm and fixed-point pre-validation',11,GRAY)
arrow([(478,959),(535,959)],GRAY,lw=1.6)
txt(563,959,'Verilog modules & testbenches',14,NAVY,'bold')
arrow([(1024,959),(1082,959)],GRAY,lw=1.6)
txt(1110,959,'Integrated FPGA design',14,NAVY,'bold')

arrow([(42,1041),(92,1041)]);txt(105,1041,'Pixel data',10,GRAY)
arrow([(265,1041),(315,1041)],TEAL,True);txt(328,1041,'Control / timing',10,GRAY)
txt(600,1041,'Functional overview; memory-IP and build details are documented separately.',10,GRAY)
fig.savefig(OUT/'block_diagram_en.svg',metadata={'Date':None})
plt.close(fig)
print(OUT/'block_diagram_en.svg')
