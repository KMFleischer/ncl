      PROGRAM INTSTL
C
C  Illustrate the various fill area interior styles.
C
      CHARACTER*7 LABEL
C
C  Open GKS, open and activate the metafile workstation.
C
      CALL GOPKS (6,IDUM)
      CALL GOPWK (1, 2, 1)
      CALL GACWK (1)
C
C  Define the necessary color indices.
C
      CALL GSCR(1,0,0.,0.,.6)
      CALL GSCR(1,1,1.,1.,1.)
      CALL GSCR(1,2,1.,0.,0.)
      CALL GSCR(1,3,0.,1.,0.)
      CALL GSCR(1,4,1.,1.,0.)
      CALL GSCR(1,5,0.,1.,1.)
      CALL GSCR(1,6,1.,0.,1.)
C
C  Draw a star with interior style hollow (the style index is
C  a dummy in this call since it is ignored for interior style
C  hollow).
C
      ISTYLE = 0
      ISTNDX = 1
      ICOLOR = 1
      CALL STAR(.35,.79,.09,ISTYLE,ISTNDX,ICOLOR)
C
C  Label the hollow area using Plotchar.
C
      CALL PCSETI('FN',21)
      CALL PCSETI('CC',4)
      CALL GSFAIS(1)
      CALL PLCHHQ(.17,.77,'Hollow',.022,0.,-1.)
C
C  Draw a star with interior style solid (the style index is
C  a dummy in this call since it is ignored for interior style
C  solid).
C
      ISTYLE = 1
      ISTNDX = 1
      ICOLOR = 1
      CALL STAR(.75,.79,.09,ISTYLE,ISTNDX,ICOLOR)
C
C  Label the solid area.
C
      CALL GSFAIS(1)
      CALL PLCHHQ(.60,.77,'Solid',.022,0.,-1.)
C
C  Draw stars with interior style hatch and with the six standardized
C  hatch styles:
C
C    Style index   Fill pattern
C    -----------   ------------
C       1          Horizontal lines
C       2          Vertical lines
C       3          Positive slope lines
C       4          Negative slope lines
C       5          Combined vertical and horizontal lines
C       6          Combined positive slope and negative slope lines
C
      DO 10 I=1,6
        X = .2+.3*REAL(MOD(I-1,3))+.02
        Y = .3*REAL(INT((9-I)/3))-.10
        SCL = .15
        ISTYLE = 3
        ISTNDX = I
        ICOLOR = I
        CALL STAR(X,Y,SCL,ISTYLE,ISTNDX,ICOLOR)
C
C  Label the hatched areas.
C
        CALL GSFAIS(1)
        CALL PLCHHQ(X-.17,Y-.004,'Hatch,',.018,0.,-1.)
        WRITE(LABEL,100) I
  100   FORMAT('index ',I1)
        CALL GSFAIS(1)
        CALL PLCHHQ(X-.17,Y-.034,LABEL,.018,0.,-1.)
   10 CONTINUE
C
C  Main plot label.
C
      CALL PCSETI('FN',26)
      CALL PCSETI('CC',4)
      CALL GSFAIS(1)
      CALL PLCHHQ(.5,.95,'Fill area interior styles',.035,0.,0.)
C
      CALL FRAME
C
C  Deactivate and close the workstation, close GKS.
C
      CALL GDAWK (1)
      CALL GCLWK (1)
      CALL GCLKS
      STOP
      END
      SUBROUTINE STAR(X,Y,SCL,ISTYLE,ISTNDX,ICOLOR)
C
C  Draw a five-pointed star with interior style ISTYLE, style index
C  ISTNDX (if applicable), and colored using the color defined by
C  color index ICOLOR.
C
      PARAMETER (ID=10)
      DIMENSION XS(ID),YS(ID),XD(ID),YD(ID)
C
C  Coordinate data for a five-pointed star.
C
      DATA XS/ 0.00000, -0.22451, -0.95105, -0.36327, -0.58780,
     -         0.00000,  0.58776,  0.36327,  0.95107,  0.22453 /
      DATA YS/ 1.00000,  0.30902,  0.30903, -0.11803, -0.80900,
     -        -0.38197, -0.80903, -0.11805,  0.30898,  0.30901 /
      SAVE
C
      DO 10 I=1,ID
        XD(I) = X+SCL*XS(I)
        YD(I) = Y+SCL*YS(I)
   10 CONTINUE
C
      CALL GSFAIS(ISTYLE)
      CALL GSFACI(ICOLOR)
      CALL GSFASI(ISTNDX)
      CALL GFA(ID,XD,YD)
C
      RETURN
      END
