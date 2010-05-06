/*
 *	ggkwdr_()
 *
 *	This function is a stub for the ggkwdr_() interface used by the 
 *	NCAR GKS package. The stub sets the status parameter to error 
 *	condition 23 ("Specified workstation type does not exist") for
 *	all invocations. 
 */
ggkwdr_(wk_id, gks_opcode, continuation,
        total_i, num_i_sent, ints,
        total_x, num_x_sent, indexes,
        total_f, num_f_sent, fxs, fys,
        total_c, num_c_sent, chars,
        status, err_msg)

        unsigned int    *wk_id;
        int     *gks_opcode, *continuation;

        int     *total_i, *num_i_sent, *ints;

        int     *total_x, *num_x_sent, *indexes;

        int     *total_f, *num_f_sent;
        float   *fxs, *fys;

        int     *total_c, *chars, *num_c_sent;

        int     *status;
        char    *err_msg;
{

	*status = 23;
}