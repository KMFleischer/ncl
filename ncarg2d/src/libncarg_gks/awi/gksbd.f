C
C	$Id: gksbd.f,v 1.6 1994-05-28 00:42:22 fred Exp $
C
      BLOCKDATA GKSBD
C
      include 'gkscom.h'
C
C
C     DESCRIPTION OF ALL GKS COMMON BLOCKS
C
C-----------------------------------------------------------------------
C
C     GKINTR:  GKS INTERNAL VARIABLES
C
C       NOPWK   -- NUMBER OF CURRENTLY OPEN WORKSTATIONS
C       NACWK   -- NUMBER OF CURRENTLY ACTIVE WORKSTATIONS
C       WCONID  -- CONNECTION IDENTIFIER FOR WISS
C       NUMSEG  -- NUMBER OF SEGMENTS CURRENTLY IN USE
C       SEGS    -- SET OF SEGMENT NAMES CURRENTLY IN USE
C       CURSEG  -- NAME OF CURRENT SEGMENT
C       SEGLEN  -- LENGTH (IN NUMBER OF RECORDS) OF THE ASSOCIATED
C                  SEGMENTS.
C       MXSREC  -- THE NUMBER OF RECORDS IN THE SEGMENT TO PROCESS
C                  IN A COPY TO A WORKSTATION
C       SEGT    -- AN ARRAY OF SEGMENT TRANSFORMATION MATRICES
C       CURTM   -- THE CURRENT SEGMET TRANSFORMATION WHEN COPYING A
C                  SEGMENT
C       SEGDEL  -- FLAG TO INDICATE WHETHER ALL SEGMENTS SHOULD BE
C                  REMOVED AT CLOSE GKS TIME (0 = NO; 1 = YES)
C       RWKSP   -- REAL WORKSPACE ARRAY
C       SEGDEL  -- FLAG TO INDICATE WHETHER GKS CLIPPING IS ON
C                  (0 = NO; 1 = YES)
C-----------------------------------------------------------------------
C
C     GKOPDT:  OPERATING STATE AND DESCRIPTION TABLE VARIABLES
C
C       OPS    --  THE GKS OPERATING STATE
C       KSLEV  --  LEVEL OF GKS
C       WK     --  NUMBER OF AVAILABLE WORKSTATION TYPES
C       LSWK   --  LIST OF AVAILABLE WORKSTATION TYPES
C       MOPWK  --  MAXIMUM NUMBER OF SIMULTANEOUSLY OPEN WORKSTATIONS
C       MACWK  --  MAXIMUM NUMBER OF SIMULTANEOUSLY ACTIVE WORKSTATIONS
C       MNT    --  MAXIMUM NORMALIZATION TRANSFORMATION NUMBER
C-----------------------------------------------------------------------
C
C     GKSTAT: GKS STATE LIST VARIABLES--
C       SOPWK  -- SET OF OPEN WORKSTATIONS
C       SACWK  -- SET OF ACTIVE WORKSTATIONS
C       CPLI   -- CURRENT POLYLINE INDEX
C       CLN    -- CURRENT LINETYPE
C       CLWSC  -- CURRENT LINEWIDTH SCALE FACTOR
C       CPLCI  -- CURRENT POLYLINE COLOR INDEX
C       CLNA   -- CURRENT LINETYPE ASF
C       CLWSCA -- CURRENT LINEWIDTH SCALE FACTOR ASF
C       CPLCIA -- CURRENT POLYLINE COLOR INDEX ASF
C       CPMI   -- CURRENT POLYMARKER INDEX
C       CMK    -- CURRENT MARKER TYPE
C       CMKS   -- CURRENT MARKER SIZE SCALE FACTOR
C       CPMCI  -- CURRENT POLYMARKER COLOR INDEX
C       CMKA   -- CURRENT MARKER TYPE ASPECT SOURCE FLAG
C       CMKSA  -- CURRENT MARKER SIZE SCALE FACTOR ASF
C       CPMCIA -- CURRENT POLYMARKER COLOR INDEX ASF
C       CTXI   -- CURRENT TEXT INDEX
C       CTXFP  -- CURRENT TEXT FONT AND PRECISION
C       CCHXP  -- CURRENT CHARACTER EXPANSION FACTOR
C       CCHSP  -- CURRENT CHARACTER SPACING
C       CTXCI  -- CURRENT TEXT COLOR INDEX
C       CTXFPA -- CURRENT TEXT FONT AND PRECISION ASF
C       CCHXPA -- CURRENT CHARACTER EXPANSION FACTOR ASF
C       CCHSPA -- CURRENT CHARACTER SPACING ASF
C       CTXCIA -- CURRENT TEXT COLOR INDEX ASF
C       CCHH   -- CURRENT CHARACTER HEIGHT
C       CCHUP  -- CURRENT CHARACTER UP VECTOR
C       CTXP   -- CURRENT TEXT PATH
C       CTXAL  -- CURRENT TEXT ALIGNMENT
C       CFAI   -- CURRENT FILL AREA INDEX
C       CFAIS  -- CURRENT FILL AREA INTERIOR STYLE
C       CFASI  -- CURRENT FILL AREA STYLE INDEX
C       CFACI  -- CURRENT FILL AREA COLOR INDEX
C       CFAISA -- CURRENT FILL AREA INTERIOR STYLE ASF
C       CFASIA -- CURRENT FILL AREA STYLE INDEX ASF
C       CFACIA -- CURRENT FILL AREA COLOR INDEX ASF
C       CPA    -- CURRENT PATTERN SIZE
C       CPARF  -- CURRENT PATTERN REFERENCE POINT
C       CNT    -- CURRENT NORMALIZATION TRANSFORMATION NUMBER
C       LSNT   -- LIST OF NORMALIZATION TRANSFORMATIONS (ORDERED
C                 BY VIEWPORT INPUT PRIORITY)
C       NTWN   -- NORMALIZATION TRANSFORMATION WINDOWS
C       NTVP   -- NORMALIZATION TRANSFORMATION VIEWPORTS
C       CCLIP  -- CURRENT CLIPPING INDICATOR
C       SWKTP  -- SET OF WORKSTATION TYPES ASSOCIATED WITH THE
C                 OPEN WORKSTATIONS
C       NOPICT -- FLAG TO INDICATE NO PICTURE ELEMENTS HAVE BEEN
C                 ISSUED FOR THE CURRENT PICTURE
C       NWKTP  -- WORKSTATION TYPE
C       LXWKID -- LOCAL X WINDOW WKID RETRIEVED FROM THE X DRIVER
C                 AT OPEN WORKSTATION TIME
C       ECONID -- THE WINDOW ID FOR WORKSTATIONS OF TYPE GXWE (EXISTING
C                 X WINDOW).  THIS VALUE IS SUPPLIED VIA THE CONNECTION
C                 ID AT OPEN WORKSTATION TIME.
C       CLLX   -- LOWER LEFT X COORDINATE FOR POSITIONING PICTURE ON PAGE
C       CLLY   -- LOWER LEFT Y COORDINATE FOR POSITIONING PICTURE ON PAGE
C       CURX   -- UPPER RIGHT X COORDINATE FOR POSITIONING PICTURE ON PAGE
C       CURY   -- UPPER RIGHT Y COORDINATE FOR POSITIONING PICTURE ON PAGE
C       CPSCL  -- SCALE FACTOR FOR POSTSCRIPT WORKSTATIONS
C       WRLDCP -- ARRAY OF WORLD COORDINATES FOR CLIPPING TO NDC VIEWPORT
C-----------------------------------------------------------------------
C
C     GKEROR:  GKS ERROR STATE LIST
C       ERS    --  ERROR STATE
C       ERF    --  ERROR FILE
C       CUFLAG --  A UTILITY FLAG THAT IS USED TO MARK THAT A PARTICULAR 
C                  WORKSTATION IS BEING ADDRESSED IN THE INTERFACE.  IF 
C                  CUFLAG IS POSITIVE, THEN IT IS EQUAL TO THE 
C                  WORKSTATION ID OF THE PARTICULAR WORKSTATION FOR 
C                  WHICH INSTRUCTIONS ARE TARGETED; IF CUFLAG = -1, THEN 
C                  INSTRUCTIONS SHOULD GO TO ALL APPROPRIAT WORKSTATIONS.
C       MXERMG --  MAXIMUM NUMBER OF ERROR MESSAGES TO ISSUE BEFORE ABORT
C                   
C-----------------------------------------------------------------------
C
C     GKENUM: GKS ENUMERATION TYPE VARIABLES
C       GBUNDL -- BUNDLED
C       GINDIV -- INDIVIDUAL
C       GGKCL  -- GKS CLOSED
C       GGKOP  -- GKS OPEN
C       GWSOP  -- WORKSTATION OPEN
C       GWSAC  -- WORKSTATION ACTIVE
C       GSGOP  -- SEGMENT OPEN
C       GOUTPT -- OUTPUT WORKSTATION
C       GINPUT -- INPUT WORKSTATION
C       GOUTIN -- OUTPUT/INPUT WORKSTATION
C       GWISS  -- WORKSTATION INDEPENDENT SEGMENT STORAGE
C       GMO    -- METAFILE OUTPUT WORKSTATION
C       GMI    -- METAFILE INPUT WORKSTATION
C       GCGM   -- WORKSTATION TYPE CGM
C       GWSS   -- WORKSTATION TYPE WISS
C       GXWE   -- WORKSTATION TYPE EXISTING COLOUR X WINDOW
C       GXWC   -- WORKSTATION TYPE COLOUR X WINDOW
C       GPSMIN -- MINIMUM TYPE FOR THE POSTSCRIPT DRIVERS
C       GPSMAX -- MAXIMUM TYPE FOR THE POSTSCRIPT DRIVERS
C
C-----------------------------------------------------------------------
C
C     GKSNAM: NAMES
C
C       GNAM   -- ARRAY OF GKS FUNCTION NAMES IS AS PER THE BINDING
C       SEGNAM -- FILE NAMES ASSOCIATED WITH THE SEGMENT NUMBERS IN
C                 VARIABLE SEGS
C       GFNAME -- FILENAME FOR MO WORKSTATIONS
C
C-----------------------------------------------------------------------
C
C     GKSIN1 & GKSIN2: WORKSTATION INTERFACE COMMON BLOCKS
C
C       FCODE  -- FUNCTION CODE FOR THE CURRENT INSTRUCTION
C       CONT   -- CONTINUATION FLAG (1 MEANS MORE TO COME; 0 MEANS LAST)
C       IL1    -- TOTAL NUMBER OF ELEMENTS TO BE PASSED IN THE ID
C                 ARRAY FOR THE CURRENT INSTRUCTION
C       IL2    -- NUMBER OF ELEMENTS IN THE ID ARRAY FOR THE GIVEN
C                 WORKSTATION INTERFACE INVOCATION
C       ID     -- ARRAY FOR PASSING INTEGERS
C       IC1    -- TOTAL NUMBER OF ELEMENTS TO BE PASSED IN THE IC
C                 ARRAY FOR THE CURRENT INSTRUCTION
C       IC2    -- NUMBER OF ELEMENTS IN THE IC ARRAY FOR THE GIVEN
C                 WORKSTATION INTERFACE INVOCATION
C       IC     -- ARRAY FOR PASSING COLOR INDICES
C       RL1    -- TOTAL NUMBER OF ELEMENTS TO BE PASSED IN THE RX AND
C                 RY ARRAYS FOR THE CURRENT INSTRUCTION
C       RL2    -- NUMBER OF ELEMENTS IN THE RX AND RY ARRAYS FOR THE
C                 GIVEN WORKSTATION INTERFACE INVOCATION
C       RX     -- ARRAY FOR PASSING REAL X COORDINATE VALUES
C       RY     -- ARRAY FOR PASSING REAL Y COORDINATE VALUES
C       STRL1  -- TOTAL NUMBER OF CHARACTERS TO BE PASSED IN THE
C                 CHARACTER VARIABLE STR FOR THE CURRENT INSTRUCTION
C       STRL2  -- NUMBER OF CHARACTERS IN THE CHARACTER VARIABLE STR
C                 FOR THE CURRENT INVOCATION OF THE WORKSTATION
C                 INTERFACE
C       RERR   -- RETURN VARIABLE FOR ERROR INDICATOR
C       STR    -- CHARACTER VARIABLE FOR PASSING CHARACTERS
C
C-----------------------------------------------------------------------
      DATA KSLEV,WK/0, 17/
      DATA LSWK/  1, 3, 7, 8,10,20,21,22,23,24,25,26,27,28,29,30,31/
      DATA MOPWK,MACWK,MNT
     +    /   15,   15,  1/
      DATA OPS/0/
      DATA ERS,ERF,CUFLAG,MXERMG/0,6,-1,10/
      DATA GBUNDL,GINDIV/0,1/
      DATA GGKCL,GGKOP,GWSOP,GWSAC,GSGOP/0,1,2,3,4/
      DATA GOUTPT,GINPUT,GOUTIN,GWISS,GMO,GMI/0,1,2,3,4,5/
      DATA GCGM,GWSS,GXWE,GXWC,GDMP,GPSMIN,GPSMAX/1,3,7,8,10,20,31/       
      DATA NOPWK,NACWK,NUMSEG,CURSEG,SEGDEL,GKSCLP/0,0,0,-1,1,1/
      DATA NOPICT/-1/
      DATA GFNAME/'DEFAULT'/
      DATA CLLX,CLLY,CURX,CURY,CPSCL/-1,-1,-1,-1,-1/
      DATA GNAM(001),GNAM(002),GNAM(003)/'GOPKS' ,'GCLKS' ,'GOPWK' /
      DATA GNAM(004),GNAM(005),GNAM(006)/'GCLWK' ,'GACWK' ,'GDAWK' /
      DATA GNAM(007),GNAM(008),GNAM(009)/'GCLRWK','GRSGWK','GUWK'  /
      DATA GNAM(010),GNAM(011),GNAM(012)/'GSDS'  ,'GMSG'  ,'GESC'  /
      DATA GNAM(013),GNAM(014),GNAM(015)/'GPL'   ,'GPM'   ,'GTX'   /
      DATA GNAM(016),GNAM(017),GNAM(018)/'GFA'   ,'GCA'   ,'GGDP'  /
      DATA GNAM(019),GNAM(020),GNAM(021)/'GSPLI' ,'GSLN'  ,'GLSWSC'/
      DATA GNAM(022),GNAM(023),GNAM(024)/'GSPLCI','GSPMI' ,'GSMK'  /
      DATA GNAM(025),GNAM(026),GNAM(027)/'GSMKSC','GSPMCI','GSTXI' /
      DATA GNAM(028),GNAM(029),GNAM(030)/'GSTXFP','GSCHXP','GSCHSP'/
      DATA GNAM(031),GNAM(032),GNAM(033)/'GSTXCI','GSCHH' ,'GSCHUP'/
      DATA GNAM(034),GNAM(035),GNAM(036)/'GSTXP' ,'GSTXAL','GSFAI' /
      DATA GNAM(037),GNAM(038),GNAM(039)/'GSFAIS','GSFASI','GSFACI'/
      DATA GNAM(040),GNAM(041),GNAM(042)/'GSPA'  ,'GSPARF','GSASF' /
      DATA GNAM(043),GNAM(044),GNAM(045)/'GSPKID','GSPLR' ,'GSPMR' /
      DATA GNAM(046),GNAM(047),GNAM(048)/'GSTXR' ,'GSFAR' ,'GSPAR' /
      DATA GNAM(049),GNAM(050),GNAM(051)/'GSCR'  ,'GSWN'  ,'GSVP'  /
      DATA GNAM(052),GNAM(053),GNAM(054)/'GSVPIP','GSELNT','GSCLIP'/
      DATA GNAM(055),GNAM(056),GNAM(057)/'GSWKWN','GSWKVP','GCRSG' /
      DATA GNAM(058),GNAM(059),GNAM(060)/'GCLSG' ,'GRENSG','GDSG'  /
      DATA GNAM(061),GNAM(062),GNAM(063)/'GDSGWK','GASGWK','GCSGWK'/
      DATA GNAM(064),GNAM(065),GNAM(066)/'GINSG' ,'GSSGT' ,'GSVIS' /
      DATA GNAM(067),GNAM(068),GNAM(069)/'GSHLIT','GSSGP' ,'GSDTEC'/
      DATA GNAM(070),GNAM(071),GNAM(072)/'GINLC' ,'GINSK' ,'GINVL' /
      DATA GNAM(073),GNAM(074),GNAM(075)/'GINCH' ,'GINPK' ,'GINST' /
      DATA GNAM(076),GNAM(077),GNAM(078)/'GSLCM' ,'GSSKM' ,'GSVLM' /
      DATA GNAM(079),GNAM(080),GNAM(081)/'GSCHM' ,'GSPKM' ,'GSSTM' /
      DATA GNAM(082),GNAM(083),GNAM(084)/'GRQLC' ,'GRQSK' ,'GRQVL' /
      DATA GNAM(085),GNAM(086),GNAM(087)/'GRQCH' ,'GRQPK' ,'GRQST' /
      DATA GNAM(088),GNAM(089),GNAM(090)/'GSMLC' ,'GSMSK' ,'GSMVL' /
      DATA GNAM(091),GNAM(092),GNAM(093)/'GSMCH' ,'GSMPK' ,'GSMST' /
      DATA GNAM(094),GNAM(095),GNAM(096)/'GWAIT' ,'GFLUSH','GGTLC' /
      DATA GNAM(097),GNAM(098),GNAM(099)/'GGTSK' ,'GGTVL' ,'GGTCH' /
      DATA GNAM(100),GNAM(101),GNAM(102)/'GGTPK' ,'GGTST' ,'GWITM' /
      DATA GNAM(103),GNAM(104),GNAM(105)/'GGTITM','GRDITM','GIITM' /
      DATA GNAM(106),GNAM(107),GNAM(108)/'GEVTM' ,'GACTM' ,'GPREC' /
      DATA GNAM(109)                    /'GUREC'                   /
      END
