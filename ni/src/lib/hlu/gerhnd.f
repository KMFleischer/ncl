C
C $Id: gerhnd.f,v 1.1 1994-09-06 21:51:31 boote Exp $
C
C****************************************************************
C								*
C			Copyright (C)  1994			*
C	University Corporation for Atmospheric Research		*
C			All Rights Reserved			*
C								*
C****************************************************************
C
C      File:            gerhnd.f
C
C      Author:          Jeff W. Boote
C                       National Center for Atmospheric Research
C                       PO 3000, Boulder, Colorado
C
C      Date:            Fri Aug 19 16:12:47 MDT 1994
C
C****************************************************************
C
C	GKS Error Handler function - this function will be called
C	in the event of a GKS error.
C
C****************************************************************
C
C If any version of GKS is used other than libncarg_gks, then
C the user will need to install thier own version of this
C function to over-ride this one, it makes calls that will
C only be resolved in libncarg_gks.
C
C We don't care about the errfil - the hlu library uses it's own
C error logging scheme.
C
      subroutine gerhnd(errnr,fctid,errfil)
	integer errnr,fctid,errfil
	character*6 fname
	character*90 mesg

	call gzname(fctid,fname)
	call gzgte2(errnr,mesg)
	call nhl_fgerhnd(fname,len(fname),mesg,len(mesg))

	return
      end
C
C	This function should always be called with 0 so the gerhnd
C	subroutine is not actually called.  It is just necessary
C	to make sure that subroutine is loaded by the time the
C	hlu library is loaded so it doesn't end up resolving to
C	the one in libncarg_gks.
C
      subroutine nhlfloadgerhnd(idum)
	integer idum
	if(idum .NE. 0) then
		call gerhnd(1,1,1)
	endif
      end
