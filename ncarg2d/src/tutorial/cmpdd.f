C
C	$Id: cmpdd.f,v 1.1 1992-09-29 16:09:50 ncargd Exp $
C
C
C Open GKS, and turn off clipping.
C
	CALL OPNGKS
	CALL GSCLIP (0)
C
C Call the mapping routine CMPDD
C
	CALL CMPDD

C
C Close GKS and quit.
C
	CALL CLSGKS

	STOP
	END

	SUBROUTINE CMPDD
C
C CMPDD demonstrates setting the dash pattern for grid lines in Maps.
C
C Set up color table.
C
	CALL COLOR
C
C Draw Continental, political outlines in magenta
C
        CALL MAPSTC ('OU - OUTLINE DATASET SELECTOR','PO')
        CALL MAPSTI ('C5 - CONTINENTAL OUTLINE COLOR',5)
        CALL MAPSTI ('C7 - COUNTRY OUTLINE COLOR',5)
C
C Draw grid lines and limb line in green
C
	CALL MAPSTI ('C2 - GRID COLOR',2)
	CALL MAPSTI ('C4 - LIMB COLOR',2)
C
C Draw labels and perimeter in white
C
	CALL MAPSTI ('C1 - PERIMETER COLOR',1)
        CALL MAPSTI ('C3 - LABEL COLOR',1)
C
C Set up satellite projection
C
	CALL MAPROJ ('SV',40.,-50.,0.)
	CALL MAPSTR ('SA - SATELLITE DISTANCE',5.)
        CALL MAPSET ('MA',0.,0.,0.,0.)
C
C Set grid spacing to 10 degrees, and anchor grid curve at 10 degree 
C intervals.
C
	CALL MAPSTR ('GR - GRID SPACING',10.)
	CALL MAPSTR ('GD - GRID DISTANCE',10.)
C
C Change the dash pattern of the grid lines to be long dashes with short
C spaces
C
	CALL MAPSTI ('DA - DASH PATTERN',64764)
C
C Initialize Maps.
C
        CALL MAPINT
C
C Draw the latitiude and longitude lines and the limb line
C
	CALL MAPGRD
C
C Advance the frame.
C
        CALL FRAME
C
C Done.
C
        RETURN
	END
      SUBROUTINE COLOR
C
C     BACKGROUND COLOR
C     BLACK
      CALL GSCR(1,0,0.,0.,0.)
C
C     FORGROUND COLORS
	CALL GSCR(1,1,1.,1.,1.)
	CALL GSCR(1,2,0.,1.,0.)
	CALL GSCR(1,3,1.,1.,0.)
	CALL GSCR(1,4,.3,.3,1.)
	CALL GSCR(1,5,1.,0.,1.)
	CALL GSCR(1,6,0.,1.,1.)
	CALL GSCR(1,7,1.,0.,0.)

	RETURN
	END