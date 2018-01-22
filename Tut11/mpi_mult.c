void mMult(int argc, char* argv[],
	int a[n][n], int b[n][n], int c[n][n])
{
	int procs;
	int rank;
	MPI_Init(&argc,&argv);
	MPI_Comm_size(MPI_COMM_WORLD, &procs);
	MPI_Comm_rank(MPI_COMM_WORLD, &rank);
	int from = rank * n/procs;
	int to = (rank+1) * n/procs;
	MPI_Bcast(b, n*n, MPI_INT, 0, MPI_COMM_WORLD);
	MPI_Scatter(a, n*n/procs, MPI_INT, a[from], n*n/procs,
	MPI_INT, 0, MPI_COMM_WORLD);
	int i,j,k;
	for (i = from; i < to; ++i) {
		for (j = 0; j < n; ++j) {
			c[i][j] = 0;
			for (k = 0; k < n; ++k) {
				c[i][j] += a[i][k] * b[k][j];
			}
		}
	}
	MPI_Gather(c[from], n*n/procs, MPI_INT, c, n*n/procs,
	MPI_INT, 0, MPI_COMM_WORLD);
	MPI_Finalize();
}