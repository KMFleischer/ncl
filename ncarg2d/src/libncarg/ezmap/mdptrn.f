C
C $Id: mdptrn.f,v 1.10 2008-09-11 04:11:37 kennison Exp $
C
C                Copyright (C)  2000
C        University Corporation for Atmospheric Research
C                All Rights Reserved
C
C The use of this Software is governed by a License Agreement.
C
      SUBROUTINE MDPTRN (RLAT,RLON,U,V)
C
        DOUBLE PRECISION RLAT,RLON,U,V
C
C Given the latitude, RLAT, and the longitude, RLON, of a point on the
C earth, this routine returns the U and V coordinates of the projection
C of that point on the map.
C
C Declare required common blocks.  See MAPBDX for descriptions of these
C common blocks and the variables in them.
C
        COMMON /MAPCM0/  COS1,DTOR,DTRH,OOPI,PI,PIOF,PIOT,RTDD,RTOD,
     +                   SROT,SIN1,TOPI,TSRT
        DOUBLE PRECISION COS1,DTOR,DTRH,OOPI,PI,PIOF,PIOT,RTDD,RTOD,
     +                   SROT,SIN1,TOPI,TSRT
        SAVE   /MAPCM0/
C
        COMMON /MAPCM1/  COSO,COSR,PLNC,SINO,SINR,IPRJ,IROD
        DOUBLE PRECISION COSO,COSR,PLNC,SINO,SINR
        INTEGER          IPRJ,IROD
        SAVE   /MAPCM1/
C
        COMMON /MAPCM2/  BLAM,BLOM,PEPS,SLAM,SLOM,UCEN,UMAX,UMIN,UOFF,
     +                   URNG,VCEN,VMAX,VMIN,VOFF,VRNG,ISSL
        DOUBLE PRECISION BLAM,BLOM,PEPS,SLAM,SLOM,UCEN,UMAX,UMIN,UOFF,
     +                   URNG,VCEN,VMAX,VMIN,VOFF,VRNG
        INTEGER          ISSL
        SAVE   /MAPCM2/
C
        COMMON /MAPCM4/  GRDR,GRID,GRLA,GRLO,GRPO,OTOL,PDRE,PLA1,PLA2,
     +                   PLA3,PLA4,PLB1,PLB2,PLB3,PLB4,PLNO,PLTO,ROTA,
     +                   SRCH,XLOW,XROW,YBOW,YTOW,IDOT,IDSH,IDTL,ILCW,
     +                   ILTS,JPRJ,ELPF,INTF,LBLF,PRMF
        DOUBLE PRECISION GRDR,GRID,GRLA,GRLO,GRPO,OTOL,PDRE,PLA1,PLA2,
     +                   PLA3,PLA4,PLB1,PLB2,PLB3,PLB4,PLNO,PLTO,ROTA,
     +                   SRCH,XLOW,XROW,YBOW,YTOW
        INTEGER          IDOT,IDSH,IDTL,ILCW,ILTS,JPRJ
        LOGICAL          ELPF,INTF,LBLF,PRMF
        SAVE   /MAPCM4/
C
        COMMON /MAPCM8/  P,Q,R
        DOUBLE PRECISION P,Q,R
        SAVE   /MAPCM8/
C
        COMMON /MAPSAT/  ALFA,BETA,DCSA,DCSB,DSNA,DSNB,SALT,SSMO,SRSS
        DOUBLE PRECISION ALFA,BETA,DCSA,DCSB,DSNA,DSNB,SALT,SSMO,SRSS
        SAVE   /MAPSAT/
C
        COMMON /USGSC1/  UTPA(15),UUMN,UUMX,UVMN,UVMX,IPRF
        DOUBLE PRECISION UTPA,UUMN,UUMX,UVMN,UVMX
        INTEGER          IPRF
        SAVE   /USGSC1/
C
C Declare local variables.
C
        DOUBLE PRECISION CHI,COSA,COSB,COSL,COSP,RLAP,RLOP,SINA,SINB,
     +                   SINL,SINP,TCOS,TEMP,TMP1,TMP2,UTM1,UTM2,UTM3,
     +                   VTM1,VTM2,VTM3,XVAL,YVAL,ZVAL
C
        REAL             USNG,VSNG
C
C Declare function types.
C
        DOUBLE PRECISION MDGDDP,RBGDFE,RBGLEN
C
C Check for an uncleared prior error.
C
        IF (ICFELL('MDPTRN - UNCLEARED PRIOR ERROR',1).NE.0) RETURN
C
C If EZMAP needs initialization, there's a problem: MDPTRN can't call
C MDPINT, because MDPINT calls MDPTRN; instead, it calls the internal
C routine MDPIN1 to initialize just the constants that it needs.
C
        IF (INTF) CALL MDPIN1
C
C Set up U and V for the fast paths.  U is a longitude, in degrees,
C between -180. and +180., inclusive, and V is a latitude, in degrees.
C
        TEMP=RLON-PLNC
        U=TEMP+(SIGN(180.D0,180.D0-TEMP)-SIGN(180.D0,TEMP+180.D0))
        V=MAX(-90.D0,MIN(90.D0,RLAT))
C
C If a fast-path projection is in use and the rotation angle is 180,
C adjust U and V.
C
        IF (IPRJ.GE.16.AND.IPRJ.LE.24.AND.
     +      ABS(ROTA).GT.179.999999D0) THEN
          U=-U
          V=-V
        END IF
C
C Take fast paths for simple cylindrical projections.
C
        IF (IPRJ-16) 100,197,118
C
C No fast path.  Sort out the USGS transformations and the Lambert
C conformal conic from the rest.
C
  100   IF (IPRJ-1) 101,102,103
C
C USGS projections.
C
  101   IF (IPRF.EQ.0) GO TO 901
C
        IF (IROD.EQ.0) THEN
          CALL MDUTFS (REAL(RLAT),REAL(RLON),USNG,VSNG)
          IF (USNG.NE.1.E12) THEN
            U=DBLE(USNG)
            V=DBLE(VSNG)
          ELSE
            U=1.D12
            V=1.D12
          END IF
        ELSE
          CALL MDUTFD (RLAT,RLON,U,V)
        END IF
C
        IF (IPRF.EQ. 3.OR.IPRF.EQ. 4.OR.IPRF.EQ. 5.OR.IPRF.EQ. 7.OR.
     +      IPRF.EQ. 8.OR.IPRF.EQ.16.OR.IPRF.EQ.17.OR.IPRF.EQ.18.OR.
     +      IPRF.EQ.19.OR.IPRF.EQ.21) THEN
          TMP1=RLON-UTPA(5)
          P=TMP1+(SIGN(180.D0,180.D0-TMP1)-SIGN(180.D0,TMP1+180.D0))
          IF ((IPRF.EQ.3.OR.IPRF.EQ.8).AND.ABS(RLAT).GT.89.999999D0)
     +                                                         GO TO 200
        ELSE IF (IPRF.EQ.9) THEN
          P=V
        ELSE IF (IPRF.EQ.11.OR.IPRF.EQ.12) THEN
          IF (MDGDDP(RLAT,RLON,UTPA(6),UTPA(5)).GT.179.99D0) GO TO 200
        ELSE IF (IPRF.EQ.20) THEN
          P=U*SIN(DTOR*UTPA(4))+V*COS(DTOR*UTPA(4))
        ELSE IF (IPRF.EQ.22) THEN
          P=U*SIN(DTOR*UTPA(4))+V*COS(DTOR*UTPA(4))
        END IF
C
        GO TO 199
C
C Lambert conformal conic.
C
  102   P=U
        CHI=90.D0-SINO*V
        IF (CHI.GT.179.999999D0) GO TO 200
        R=TAN(DTRH*CHI)**COSO
        U=U*COSO*DTOR
        V=-R*SINO*COS(U)
        U=R*SIN(U)
        GO TO 198
C
C Not Lambert conformal conic.  Calculate constants common to most of
C the other projections.  
C
C Note (09/10/2008): This code treats the azimuthal projections and the
C cylindrical and mixed projections differently.  Originally, the code
C for "IPRJ.GE.7" (the second block of the block-IF) wasn't there; the
C statement "IF (COSA.LT. ... " read "IF (IPRJ.GE.7.OR.COSA.LT. ...".
C This had the undesirable effect of treating certain points on the
C globe as not projectable when, if fact, they were.
C
C (This comment is for use in the unlikely event that the need arises
C to resurrect the technique.  Search for "C Note (09/10/2008)" to find
C all comments about it.)
C
  103   SINL=SIN(U*DTOR)
        COSL=COS(U*DTOR)
        SINP=SIN(V*DTOR)
        COSP=COS(V*DTOR)
        IF (IPRJ.LT.7) THEN
          TCOS=COSP*COSL
          COSA=MAX(-1.D0,MIN(+1.D0,SINP*SINO+TCOS*COSO))
          SINA=SQRT(1.D0-COSA*COSA)
          IF (SINA.LT..000001D0) THEN
            SINA=0.D0
            IF (IPRJ.EQ.3.AND.ABS(SALT).GT.1.D0) THEN
              SINB=0.D0
              COSB=1.D0
              GO TO 105
            END IF
            IF (COSA.LT.0.D0) GO TO 200
            U=0.D0
            V=0.D0
            GO TO 197
          END IF
          SINB=COSP*SINL/SINA
          COSB=(SINP*COSO-TCOS*SINO)/SINA
        ELSE
          XVAL=COSL*COSP*COSO+SINP*SINO
          YVAL=SINL*COSP*COSR+(SINP*COSO-COSL*COSP*SINO)*SINR
          ZVAL=(SINP*COSO-COSL*COSP*SINO)*COSR-SINL*COSP*SINR
          RLAP=ASIN(MAX(-1.D0,MIN(+1.D0,ZVAL)))
          RLOP=ATAN2(YVAL,XVAL)
        END IF
C
C Jump to code appropriate for the chosen projection.
C
C Projection:   ST  OR  LE  GN  AE
C               CE  ME  MT  RO  EA  AI  HA  MO  WT  (arbitrary)
C
        GO TO (104,105,106,107,108,
     +         109,110,111,112,113,114,115,116,117) , IPRJ-1
C
C Stereographic.
C
  104   IF (ABS(SINA).LT..000001D0) THEN
          R=SINA/2.D0
        ELSE
          R=(1.D0-COSA)/SINA
        END IF
        GO TO 196
C
C Orthographic or satellite-view, depending on the value of SALT.
C
  105   IF (ABS(SALT).LE.1.D0) THEN
          IF (COSA.GT.0.D0) THEN
            R=SINA
          ELSE
            IF (SALT.GE.0.D0) GO TO 200
            R=2.D0-SINA
          END IF
          GO TO 196
        ELSE
          IF (COSA.GT.1.D0/ABS(SALT)) THEN
            R=SRSS*SINA/(ABS(SALT)-COSA)
          ELSE
            IF (SALT.GE.0.D0) GO TO 200
            R=2.D0-SRSS*SINA/(ABS(SALT)-COSA)
          END IF
          IF (ALFA.EQ.0.D0) GO TO 196
          UTM1=R*(SINB*COSR+COSB*SINR)
          VTM1=R*(COSB*COSR-SINB*SINR)
          UTM2=UTM1*DCSB+VTM1*DSNB
          VTM2=VTM1*DCSB-UTM1*DSNB
          IF ((SRSS*DCSA+UTM2*DSNA)/SRSS.LT..0001D0) GO TO 200
          UTM3=SRSS*(UTM2*DCSA-SRSS*DSNA)/
     +                    (UTM2*DSNA+SRSS*DCSA)
          VTM3=SRSS*VTM2/(UTM2*DSNA+SRSS*DCSA)
          U=UTM3*DCSB-VTM3*DSNB
          V=VTM3*DCSB+UTM3*DSNB
          GO TO 197
        END IF
C
C Lambert equal area.
C
  106   IF (ABS(COSA+1.D0).LT..000001D0) GO TO 200
        R=(1.D0+COSA)/SINA
        R=2.D0/SQRT(1.D0+R*R)
        GO TO 196
C
C Gnomonic.
C
  107   IF (COSA.LE..000001D0) GO TO 200
        R=SINA/COSA
        GO TO 196
C
C Azimuthal equidistant.
C
  108   IF (ABS(COSA+1.D0).LT..000001D0) GO TO 200
        R=ACOS(COSA)
        GO TO 196
C
C Cylindrical equidistant, arbitrary pole and orientation.
C
C Note (09/10/2008): Using the abandoned technique mentioned in other
C notes in MDPIN1 and above, computing the cylindrical equidistant U
C and V required the following statements:
C
C   U=ATAN2(SINB*COSR+COSB*SINR,SINB*SINR-COSB*COSR)*RTOD
C   V=90.D0-ACOS(COSA)*RTOD.
C
C Similar code was required for the non-fast-path versions of all the
C cylindrical and mixed projections.
C
C (This comment is for use in the unlikely event that the need arises
C to resurrect the technique.  Search for "C Note (09/10/2008)" to find
C all comments about it.)
C
  109   U=RLOP*RTOD
        V=RLAP*RTOD
        GO TO 197
C
C Mercator, arbitrary pole and orientation.
C
  110   IF (ABS(RLAP*RTOD).GT.89.999999D0) GO TO 200
        U=RLOP
        V=LOG(TAN((RLAP+PIOT)/2.D0))
        GO TO 197
C
C Mollweide-type, arbitrary pole and orientation.
C
  111   P=RLOP*TOPI
        V=SIN(RLAP)
        U=P*SQRT(1.D0-V*V)
        GO TO 198
C
C Robinson, arbitrary pole and orientation.
C
  112   P=RLOP*OOPI
        U=P*RBGLEN(RLAP*RTOD)
        V=RBGDFE(RLAP*RTOD)
        GO TO 198
C
C Cylindrical equal-area, arbitrary pole and orientation.
C
  113   U=RLOP
        V=SIN(RLAP)*4.D0/3.D0
        GO TO 197
C
C Aitoff, arbitrary pole and orientation.
C
  114   CALL AIPROJ (RLAP,RLOP,U,V)
        P=RLOP
        GO TO 198
C
C Hammer, arbitrary pole and orientation.
C
  115   CALL HAPROJ (RLAP,RLOP,U,V)
        P=TSRT*RLOP/PI
        GO TO 198
C
C True Mollweide, arbitrary pole and orientation.
C
  116   CALL MOPROJ (RLAP,RLOP,U,V)
        P=TSRT*RLOP/PI
        GO TO 198
C
C Winkel tripel, arbitrary pole and orientation.
C
  117   CALL WTPROJ (RLAP,RLOP,U,V)
        P=RLOP
        GO TO 198
C
C Fast-path cylindrical projections (with PLAT=0, ROTA=0 or 180).
C
C Projection:   ME  MT  RO  EA  AI  HA  MO  WT  RM  (fast-path)
C
  118   GO TO (119,120,121,122,123,124,125,126,127) , IPRJ-16
C
C Mercator, fast-path.
C
  119   IF (ABS(V).GT.89.999999D0) GO TO 200
        U=U*DTOR
        V=LOG(TAN((V+90.D0)*DTRH))
        GO TO 197
C
C Mollweide-type, fast-path.
C
  120   P=U/90.D0
        V=SIN(V*DTOR)
        U=P*SQRT(1.D0-V*V)
        GO TO 198
C
C Robinson, fast-path.
C
  121   P=U/180.D0
        U=P*RBGLEN(V)
        V=RBGDFE(V)
        GO TO 198
C
C Cylindrical equal-area, fast-path.
C
  122   U=U*DTOR
        V=SIN(V*DTOR)*4.D0/3.D0
        GO TO 197
C
C Aitoff, fast-path.
C
  123   P=DTOR*U
        RLAP=V*DTOR
        RLOP=U*DTOR
        CALL AIPROJ (RLAP,RLOP,U,V)
        GO TO 198
C
C Hammer, fast-path.
C
  124   P=TSRT*U/180.D0
        RLAP=V*DTOR
        RLOP=U*DTOR
        CALL HAPROJ (RLAP,RLOP,U,V)
        GO TO 198
C
C True Mollweide, fast-path.
C
  125   P=TSRT*U/180.D0
        RLAP=V*DTOR
        RLOP=U*DTOR
        CALL MOPROJ (RLAP,RLOP,U,V)
        GO TO 198
C
C Winkel tripel, fast-path.
C
  126   P=DTOR*U
        RLAP=V*DTOR
        RLOP=U*DTOR
        CALL WTPROJ (RLAP,RLOP,U,V)
        GO TO 198
C
C Rotated Mercator.
C
  127   IF (ABS(V).GT.89.999999D0) GO TO 200
        UTM1=U*DTOR
        VTM1=LOG(TAN((V+90.D0)*DTRH))
        P=U
        Q=V
        U=UTM1*COSR+VTM1*SINR
        V=VTM1*COSR-UTM1*SINR
        GO TO 199
C
C Common terminal code for certain projections.
C
  196   U=R*(SINB*COSR+COSB*SINR)
        V=R*(COSB*COSR-SINB*SINR)
C
  197   P=U
C
  198   Q=V
C
C Normal exit.
C
  199   U=U-UOFF
        V=V-VOFF
C
        RETURN
C
C Projection of point is invisible or undefined.
C
  200   U=1.D12
        P=U
C
        RETURN
C
C Error exit.
C
  901   CALL SETER ('MDPTRN - USGS PROJECTION WAS NOT INITIALIZED',2,1)
        RETURN
C
      END
