/*
 *      $Id: browse.h,v 1.6 1998-11-18 19:45:16 dbrown Exp $
 */
/************************************************************************
*									*
*			     Copyright (C)  1996			*
*	     University Corporation for Atmospheric Research		*
*			     All Rights Reserved			*
*									*
************************************************************************/
/*
 *	File:		browse.h
 *
 *	Author:		David I. Brown
 *			National Center for Atmospheric Research
 *			PO 3000, Boulder, Colorado
 *
 *	Date:		Tue Mar  4 12:38:45 MST 1997
 *
 *	Description:	
 */
#ifndef	_NG_BROWSE_H
#define	_NG_BROWSE_H

#include <ncarg/ngo/go.h>
#include <ncarg/hlu/NresDB.h>

extern NhlClass NgbrowseClass;

/*
 * Public api
 */

typedef enum _brPageType 
{
        _brNULL, _brREGVAR, _brFILEREF, _brFILEVAR, _brHLUVAR
} brPageType;

#define NgNoPage 0
typedef int NgPageId;

typedef void (*AdjustPageGeoFunc) (
 	NhlPointer data
);

typedef void (*PageOutputNotify) (
        NhlPointer	pdata,
        NgPageId	page_id
);

extern NgPageId NgOpenPage(
        int		goid,
        brPageType	type,
        NrmQuark	*qname,
        int		qcount
        );

extern void NgPageOutputNotify(
        int		goid,
        NgPageId	page_id,
        brPageType	output_page_type,
        NhlPointer	output_data
        );

extern NhlPointer NgPageData(
        int		goid,
        NgPageId	page_id
        );

extern NhlErrorTypes NgUpdatePage(
        int		goid,
        NgPageId	page_id
        );

extern NhlErrorTypes NgDeletePage(
        int		goid,
        NgPageId	page_id
        );

extern int NgGetPageId(
        int		goid,
        NrmQuark	qsym1,
        NrmQuark	qsym2
        );

extern NhlErrorTypes NgPageSetVisible(
        int		goid,
        NgPageId	page_id,
        Widget		requestor,
        XRectangle	*rect
        );


#endif	/* _NG_BROWSE_H */
