C
C $Id: supcon.f,v 1.15 2008-09-11 04:11:38 kennison Exp $
C
C                Copyright (C)  2000
C        University Corporation for Atmospheric Research
C                All Rights Reserved
C
C The use of this Software is governed by a License Agreement.
C
      SUBROUTINE SUPCON (RLAT,RLON,UVAL,VVAL)
        REAL   RLAT,RLON,UVAL,VVAL
        DOUBLE PRECISION DUVL,DVVL
        IF (ICFELL('SUPCON - UNCLEARED PRIOR ERROR',1).NE.0) RETURN
        CALL MDPTRN (DBLE(RLAT),DBLE(RLON),DUVL,DVVL)
        IF (ICFELL('SUPCON',2).NE.0) RETURN
        IF (DUVL.NE.1.D12) THEN
          UVAL=REAL(DUVL)
          VVAL=REAL(DVVL)
        ELSE
          UVAL=1.E12
          VVAL=1.E12
        END IF
        RETURN
      END
