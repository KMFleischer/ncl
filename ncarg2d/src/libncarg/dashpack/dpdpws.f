C
C $Id: dpdpws.f,v 1.2 2004-11-17 18:09:25 kennison Exp $
C
C                Copyright (C)  2000
C        University Corporation for Atmospheric Research
C                All Rights Reserved
C
C This file is free software; you can redistribute it and/or modify
C it under the terms of the GNU General Public License as published
C by the Free Software Foundation; either version 2 of the License, or
C (at your option) any later version.
C
C This software is distributed in the hope that it will be useful, but
C WITHOUT ANY WARRANTY; without even the implied warranty of
C MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
C General Public License for more details.
C
C You should have received a copy of the GNU General Public License
C along with this software; if not, write to the Free Software
C Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
C USA.
C
      SUBROUTINE DPDPWS (DPCH,DSYM,DPAT)
C
        CHARACTER*(*) DPCH,DSYM,DPAT
C
C This routine is called with three character strings of the same
C length: the input string DPCH is a basic dash pattern, to be used
C with DASHPACK, containing some characters that are to be treated
C as symbol generators; the input string DSYM contains characters
C other than blanks or minus signs in the positions corresponding to
C characters of DPCH that are to be treated as symbol generators; and
C the output string DPAT is the appropriate character string to be
C input to DASHPACK by a call to DPSETC.
C
C For example, to get a dash pattern specifying alternate solid-line
C segments and filled circles, use this:
C
C   DPCH: '$0'  !  (The '$' means "solid"; the '0' selects a symbol.)
C   DSYM: ' #'  !  (Use any character but ' ' or '-' in lieu of '#'.)
C
C To get a dash pattern specifying a solid section, the characters
C "I=1", another solid section, and a hollow-circle symbol, use this:
C
C   DPCH: '$$$I|=|1$$$5'  !  (A final '5' selects the desired symbol.)
C   DSYM: '-----------+'  !  (A plus sign marks the symbol position.)
C
C (Note the use of break characters - '|' - in the character string to
C allow the string to be written bending with a curve being drawn.)
C
C By default, symbol-selection characters which may be used include
C the following:
C
C   0 => filled circle         5 => hollow circle
C   1 => filled square         6 => hollow square
C   2 => filled triangle       7 => hollow triangle
C   3 => filled diamond        8 => hollow diamond
C   4 => filled star           9 => hollow star
C
C See also the DASHPACK routine DPDSYM; it actually draws the symbols
C and may be replaced by a user to draw a different set.
C
        LPAT=LEN(DPAT)
C
        DO 101 I=1,LPAT
          IF (DSYM(I:I).EQ.' '.OR.DSYM(I:I).EQ.'-') THEN
            DPAT(I:I)=DPCH(I:I)
          ELSE
            DPAT(I:I)=CHAR(IOR(ICHAR(DPCH(I:I)),128))
          END IF
  101   CONTINUE
C
        RETURN
C
      END
