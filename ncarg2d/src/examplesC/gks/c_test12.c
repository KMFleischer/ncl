#include <stdio.h>

#include <ncarg/ncargC.h>
#include <ncarg/gks.h>

#define WSTYPE SED_WSTYPE
#define WKID   1

main()
{
/*
 *  Draw a single line.
 */
    Gescape_in_data in_data;
    char idr[80], odr[80];
    Gpoint_list points;

    points.num_points = 2;
    points.points = (Gpoint *)malloc(2*sizeof(Gpoint));
    points.points[0].x = 1.;
    points.points[1].x = 0.;
    points.points[0].y = 0.;
    points.points[1].y = 1.;
/*
 *  Open GKS.
 */
    gopen_gks("stdout",0);
/*
 *  Open the X workstation.
 */
    gopen_ws(WKID,0,WSTYPE);
/*
 *  Activate the X workstation.
 */
    gactivate_ws(WKID);

    gpolyline(&points);
    gupd_ws(WKID,0);
    in_data.escape_r1.data = (Gdata *)malloc(5*sizeof(char));
    strcpy(in_data.escape_r1.data, "    1");
    in_data.escape_r1.size = 5;
    gescape(-1396,&in_data,NULL,NULL);

    gdeactivate_ws(WKID);
    gclose_ws(WKID);
    gclose_gks();
}