C
C $Id: mapgtd.f,v 1.6 2008-09-11 04:11:36 kennison Exp $
C
C                Copyright (C)  2000
C        University Corporation for Atmospheric Research
C                All Rights Reserved
C
C The use of this Software is governed by a License Agreement.
C
      SUBROUTINE MAPGTD (WHCH,DVAL)
        CHARACTER*(*)    WHCH
        DOUBLE PRECISION DVAL
        IF (ICFELL('MAPGTD - UNCLEARED PRIOR ERROR',1).NE.0) RETURN
        CALL MDGETD (WHCH,DVAL)
        IF (ICFELL('MAPGTD',2).NE.0) RETURN
        RETURN
      END
