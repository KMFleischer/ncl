/*
 *	$Id: xwd.c,v 1.8 1992-03-23 21:46:11 clyne Exp $
 */
/***********************************************************************
*                                                                      *
*                          Copyright (C)  1991                         *
*            University Corporation for Atmospheric Research           *
*                          All Rights Reserved                         *
*                                                                      *
*                                                                      *
***********************************************************************/
/*	File:	xwd.c
 *
 *	Author: Don Middleton
 *		National Center for Atmospheric Research
 *		Scientific Visualization Group
 *		Boulder, Colorado 80307
 *
 *	Date:	1/31/91
 *
 *	Description:
 *		This file contains a collection of functions
 *		which provides access to a raster sequence
 *		using a general abstraction.
 *
 *		This particular set of routines provides
 *		basic file access functions for XWD (X Window
 *		System Dump) files.
 *
 *		Encoding schemes are limited to:
 *			* 8-bit indexed	color with 8-bit color map values.
 *		
 */
#ifndef CRAY
#include <fcntl.h>
#include <sys/types.h>
#endif /* CRAY */

#include <X11/Xos.h>
#include <X11/Xlib.h>
#include <X11/Xutil.h>
#include <X11/XWDFile.h>
#include <malloc.h>
#include "ncarg_ras.h"

static char	*FormatName = "xwd";
extern char	*ProgramName;
static char	*Comment = "XWD file from NCAR raster utilities";

Raster *
XWDOpen(name)
	char	*name;
{
	Raster		*ras;

#ifdef	hpux
	void		*calloc();
#else
#ifndef CRAY
	char		*calloc();
#endif /* CRAY */
#endif /* hpux */

	XWDFileHeader	*dep;

	if (name == (char *) NULL) {
		(void) RasterSetError(RAS_E_NULL_NAME);
		return( (Raster *) NULL );
	}

	ras = (Raster *) calloc(sizeof(Raster), 1);
	if (ras == (Raster *) NULL) {
		(void) RasterSetError(RAS_E_SYSTEM);
		return( (Raster *) NULL );
	}

	ras->dep = calloc(sizeof(XWDFileHeader),1);
	if (ras->dep == (char *) NULL) {
		(void) RasterSetError(RAS_E_SYSTEM);
		return( (Raster *) NULL );
	}
	
	dep = (XWDFileHeader *) ras->dep;

	/* Tell other routines structure hasn't been filled. */

	dep->pixmap_width = 0;

	/* Set up file descriptors and pointers. */

	if (!strcmp(name, "stdin")) {
		ras->fd = fileno(stdin);
		ras->fp = stdin;
	}
	else {
		ras->fd  = open(name, O_RDONLY);
		if (ras->fd == -1) {
			(void) RasterSetError(RAS_E_SYSTEM);
			return( (Raster *) NULL );
		}

		ras->fp = fdopen(ras->fd, "r");

		if (ras->fp == (FILE *) NULL) {
			(void) RasterSetError(RAS_E_SYSTEM);
			return( (Raster *) NULL );
		}
	}

	ras->name = (char *) calloc((unsigned) strlen(name) + 1, 1);
	(void) strcpy(ras->name, name);

	ras->format = (char *) calloc((unsigned) strlen(FormatName) + 1, 1);
	(void) strcpy(ras->format, FormatName);

	XWDSetFunctions(ras);

	return(ras);
}

int
XWDPrintInfo(ras)
	Raster	*ras;
{
	XWDFileHeader	*dep;

	(void) fprintf(stderr, "\n");
	(void) fprintf(stderr, "XWD Rasterfile Information\n");
	(void) fprintf(stderr, "--------------------------\n");

	dep = (XWDFileHeader *) ras->dep;
	(void) fprintf(stderr, "header_size      %d\n", dep->header_size);
	(void) fprintf(stderr, "file_version     %d\n", dep->file_version);
	(void) fprintf(stderr, "pixmap_format    %d\n", dep->pixmap_format);
	(void) fprintf(stderr, "pixmap_depth     %d\n", dep->pixmap_depth);
	(void) fprintf(stderr, "pixmap_width     %d\n", dep->pixmap_width);
	(void) fprintf(stderr, "pixmap_height    %d\n", dep->pixmap_height);
	(void) fprintf(stderr, "xoffset          %d\n", dep->xoffset);
	(void) fprintf(stderr, "byte_order       %d\n", dep->byte_order);
	(void) fprintf(stderr, "bitmap_unit      %d\n", dep->bitmap_unit);
	(void) fprintf(stderr, "bitmap_bit_order %d\n", dep->bitmap_bit_order);
	(void) fprintf(stderr, "bitmap_pad       %d\n", dep->bitmap_pad);
	(void) fprintf(stderr, "bits_per_pixel   %d\n", dep->bits_per_pixel);
	(void) fprintf(stderr, "bytes_per_line   %d\n", dep->bytes_per_line);
	(void) fprintf(stderr, "visual_class     %d\n", dep->visual_class);
	(void) fprintf(stderr, "red_mask         %d\n", dep->red_mask);
	(void) fprintf(stderr, "green_mask       %d\n", dep->green_mask);
	(void) fprintf(stderr, "blue_mask        %d\n", dep->blue_mask);
	(void) fprintf(stderr, "bits_per_rgb     %d\n", dep->bits_per_rgb);
	(void) fprintf(stderr, "colormap_entries %d\n", dep->colormap_entries);
	(void) fprintf(stderr, "ncolors          %d\n", dep->ncolors);
	(void) fprintf(stderr, "window_width     %d\n", dep->window_width);
	(void) fprintf(stderr, "window_height    %d\n", dep->window_height);
	(void) fprintf(stderr, "window_x         %d\n", dep->window_x);
	(void) fprintf(stderr, "window_y         %d\n", dep->window_y);
	(void) fprintf(stderr, "window_bdrwidth  %d\n", dep->window_bdrwidth);
	return(RAS_OK);
}

/*
 *
 *	Author:		John Clyne
 *
 *	Date		Mon Mar 30 14:25:43 MST 1990
 *
 *	XWDRead:
 *
 *	read in the next image from a X dump. read_8bit_raster sequentially
 *	reads in images from a X dump file with each invocation. It than
 *	converts the image to something the sun library routines can handle
 *
 * on entry:
 *	xdump_fd	: file descriptor for X dump file
 * on exit
 *	*raster_data	: contains data for a single image
 *	return		: 0 => EOF, < 0 => failure, else ok
 */

int
XWDRead(ras)
	Raster	*ras;
{
	XWDFileHeader		*dep;		/* Format dependent struct */
	XWDFileHeader		old_dep;
	static unsigned		buffer_size;	/* size of image	*/
	unsigned char		*cptr1, *cptr2;
	int			status, i;
	XColor			xcolors[256];	/* color palette in X dump */
	int			win_name_size;	/* not used */
	unsigned		image_size();
	static unsigned long 	swaptest = 1;

	/* Stash a copy of "dep" in order to check for mixed image sizes. */
	/* Read in header, "dep" is format dependent data. */

	dep = (XWDFileHeader *) ras->dep;
	bcopy((char *) dep, (char *) &old_dep, sizeof(XWDFileHeader));

	status = fread( (char *)dep, 1, sizeof(XWDFileHeader), ras->fp);
	if (status != sizeof(XWDFileHeader)) return(RAS_EOF);

	if (*(char *) &swaptest) {
		_swaplong((char *) dep, sizeof(XWDFileHeader));
	}

	/* Check to see if the xwd file is the proper revision. */

	if (dep->file_version != XWD_FILE_VERSION) {
		(void) fprintf(stderr, "XWD file format version mismatch\n");
	}

	if (dep->header_size < sizeof(XWDFileHeader)) {
		(void) RasterSetError(RAS_E_NOT_IN_CORRECT_FORMAT);
		return(RAS_ERROR);
	}

	ras->nx = dep->pixmap_width;
	ras->ny = dep->pixmap_height;
	ras->length = ras->nx * ras->ny;

	if (dep->ncolors > 256) {
		(void) RasterSetError(RAS_E_COLORMAP_TOO_BIG);
		return(RAS_ERROR);
	}

	ras->ncolor = dep->ncolors;
			
	/* Make sure we have a format we can handle */

	if (dep->pixmap_format != ZPixmap) {
		(void) RasterSetError(RAS_E_UNSUPPORTED_ENCODING);
		return(RAS_ERROR);
	}

	if (dep->pixmap_depth == 8 && dep->bits_per_pixel == 8) {
		ras->type = RAS_INDEXED;
	}
	else {
		(void) RasterSetError(RAS_E_8BIT_PIXELS_ONLY);
		return(RAS_ERROR);
	}

	/* If this is the first read on this Raster structure, */
	/* allocate the necessary memory. Otherwise, make sure */
	/* that the image size hasn't changed between frames   */

	if (ras->data == (unsigned char *) NULL) {
		buffer_size = image_size(dep);
		ras->data = (unsigned char *) malloc (buffer_size);
		if (ras->data == (unsigned char *) NULL) {
			(void) RasterSetError(RAS_E_SYSTEM);
			return(RAS_ERROR);
		}

		ras->red = (unsigned char *) calloc((unsigned) ras->ncolor, 1);
		ras->green = (unsigned char *) calloc((unsigned) ras->ncolor,1);
		ras->blue = (unsigned char *) calloc((unsigned) ras->ncolor, 1);
	}
	else {
		if (dep->pixmap_width != old_dep.pixmap_width) {
			(void) RasterSetError(RAS_E_IMAGE_SIZE_CHANGED);
			return(RAS_ERROR);
		}

		if (dep->pixmap_height != old_dep.pixmap_height) {
			(void) RasterSetError(RAS_E_IMAGE_SIZE_CHANGED);
			return(RAS_ERROR);
		}
	}

	/* Read in the window name (not used) */

	win_name_size = (dep->header_size - sizeof(XWDFileHeader));
	if ((ras->text = malloc((unsigned) win_name_size)) == NULL) {
		(void) RasterSetError(RAS_E_SYSTEM);
		return(RAS_ERROR);
	}

	status = fread(ras->text, 1, win_name_size, ras->fp);
	if (status != win_name_size) return(RAS_EOF);

	/* Read in the color palette */

	status  = fread((char *) xcolors, 1, 
		(int) (ras->ncolor * sizeof(XColor)), ras->fp);
	if (status != ras->ncolor * sizeof(XColor)) return(RAS_EOF);

	/* Swap bytes in the color table, if appropriate. */

	if (*(char *) &swaptest) {
		for (i = 0; i < ras->ncolor; i++) {
			_swaplong((char *) &xcolors[i].pixel, sizeof(long));
			_swapshort((char *) &xcolors[i].red, 3 * sizeof(short));
		}
        }

	/* Load ras with the color palette, if there isn't one already. */

	if (ras->map_loaded != True) {
		for (i = 0; i < ras->ncolor; i++ ) {
			ras->red[i]	= xcolors[i].red / 256;
			ras->green[i]	= xcolors[i].green / 256;
			ras->blue[i]	= xcolors[i].blue / 256;
		}
	}
	
	/* Read in the image */

	status   = fread((char *) ras->data, 1, (int) buffer_size, ras->fp);
	if (status != buffer_size) return(RAS_EOF);

	/* Remove padding if it exists (X dumps padded to word boundaries) */

	if (dep->bytes_per_line - dep->pixmap_width) {
		cptr1 = ras->data + ras->nx;
		cptr2 = ras->data + dep->bytes_per_line;
		for (i = 1; i < dep->pixmap_height; i++) {
			bcopy((char *) cptr2, (char *) cptr1, ras->nx);
			cptr1 += ras->nx; 
			cptr2 += dep->bytes_per_line;
		}
	}
			
	return(RAS_OK);
}

unsigned
image_size(header)
	XWDFileHeader *header;
{
	if (header->pixmap_format != ZPixmap)
		return(header->bytes_per_line * header->pixmap_height * 
			header->pixmap_depth);

	return((unsigned)header->bytes_per_line * header->pixmap_height);
}

/*ARGSUSED*/
Raster *
XWDOpenWrite(name, nx, ny, comment, encoding)
	char		*name;
	int		nx;
	int		ny;
	char		*comment;
	int		encoding;
{
	Raster		*ras;
	XWDFileHeader	*dep;

	if (name == (char *) NULL) {
		(void) RasterSetError(RAS_E_NULL_NAME);
		return( (Raster *) NULL );
	}

	ras = (Raster *) calloc(sizeof(Raster), 1);

	ras->dep = calloc(sizeof(XWDFileHeader),1);

	dep = (XWDFileHeader *) ras->dep;

	if (ras == (Raster *) NULL) {
		(void) RasterSetError(RAS_E_SYSTEM);
		return( (Raster *) NULL );
	}

	if (!strcmp(name, "stdout")) {
		ras->fd = fileno(stdout);
	}
	else {
		ras->fd = open(name, O_WRONLY | O_CREAT, 0644);

		if (ras->fd == -1) {
			(void) RasterSetError(RAS_E_SYSTEM);
			return( (Raster *) NULL );
		}
	}

	ras->name = (char *) calloc((unsigned) strlen(name) + 1, 1);
	(void) strcpy(ras->name, name);

	ras->format = (char *) calloc((unsigned) strlen(FormatName) + 1, 1);
	(void) strcpy(ras->format, FormatName);

	ras->nx	= nx;
	ras->ny	= ny;
	ras->length	= ras->nx * ras->ny;
	ras->ncolor	= 256;
	ras->type	= RAS_INDEXED;
	ras->red	= (unsigned char *) calloc((unsigned) ras->ncolor, 1);
	ras->green	= (unsigned char *) calloc((unsigned) ras->ncolor, 1);
	ras->blue	= (unsigned char *) calloc((unsigned) ras->ncolor, 1);
	ras->data	= (unsigned char *) calloc((unsigned) ras->length, 1);

	if (encoding != RAS_INDEXED) {
		(void) RasterSetError(RAS_E_UNSUPPORTED_ENCODING);
		return( (Raster *) NULL );
	}
	else {
		ras->type = RAS_INDEXED;
	}

	dep->header_size	= sizeof(XWDFileHeader) + strlen(Comment);
	dep->file_version	= XWD_FILE_VERSION;
	dep->pixmap_format	= ZPixmap;
	dep->pixmap_depth	= 8;
	dep->pixmap_width	= nx;
	dep->pixmap_height	= ny;
	dep->xoffset		= 0;
	dep->byte_order		= 1;
	dep->bitmap_unit	= 32;
	dep->bitmap_bit_order	= 1;
	dep->bitmap_pad		= 32;
	dep->bits_per_pixel	= 8;
	dep->bytes_per_line	= nx;
	dep->visual_class	= PseudoColor;
	dep->red_mask		= 0;
	dep->green_mask		= 0;
	dep->blue_mask		= 0;
	dep->bits_per_rgb	= 8;
	dep->colormap_entries	= 256;
	dep->ncolors		= 256;
	dep->window_width	= nx;
	dep->window_height	= ny;
	dep->window_x		= 0;
	dep->window_y		= 0;
	dep->window_bdrwidth	= 0;

	XWDSetFunctions(ras);

	return(ras);
}

int
XWDWrite(ras)
	Raster	*ras;
{
	XColor		xcolors[256];		/* color palette in X dump */
	int		nb;
	int		i;
	unsigned long	swaptest = 1;

	if (*(char *) &swaptest) {
		_swaplong((char *) ras->dep, sizeof(XWDFileHeader));
	}

	nb = write(ras->fd, (char *) ras->dep, sizeof(XWDFileHeader));
	if (nb != sizeof(XWDFileHeader)) return(RAS_EOF);

	nb = write(ras->fd, Comment, strlen(Comment));
	if (nb != strlen(Comment)) return(RAS_EOF);

	for(i=0; i<ras->ncolor; i++) {
		xcolors[i].red = ras->red[i] * 256;
		xcolors[i].green = ras->green[i] * 256;
		xcolors[i].blue = ras->blue[i] * 256;
	}

	/* Swap bytes in the color table, if appropriate. */

	if (*(char *) &swaptest) {
		for (i = 0; i < ras->ncolor; i++) {
			_swaplong((char *) &xcolors[i].pixel, sizeof(long));
			_swapshort((char *) &xcolors[i].red, 3 * sizeof(short));
		}
        }

	nb = write(ras->fd, (char *) xcolors, sizeof(xcolors));
	if (nb != sizeof(xcolors)) return(RAS_EOF);

	nb = write(ras->fd, (char *) ras->data, ras->nx * ras->ny);
	if (nb != ras->nx * ras->ny) return(RAS_EOF);

	return(RAS_OK);
}

int
XWDClose(ras)
	Raster	*ras;
{
	free((char *) ras->data);
	free((char *) ras->red);
	free((char *) ras->green);
	free((char *) ras->blue);
	if (ras->fd >= 0) (void) close(ras->fd);
	free((char *) ras);
	return(RAS_OK);
}

int
XWDSetFunctions(ras)
	Raster	*ras;
{
	extern	int	ImageCount_();

	ras->Open        = XWDOpen;
	ras->OpenWrite   = XWDOpenWrite;
	ras->Read        = XWDRead;
	ras->Write       = XWDWrite;
	ras->Close       = XWDClose;
	ras->PrintInfo   = XWDPrintInfo;
	ras->ImageCount  = ImageCount_;
}
