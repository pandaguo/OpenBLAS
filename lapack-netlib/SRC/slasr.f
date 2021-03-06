*> \brief \b SLASR applies a sequence of plane rotations to a general rectangular matrix.
*
*  =========== DOCUMENTATION ===========
*
* Online html documentation available at
*            http://www.netlib.org/lapack/explore-html/
*
*> \htmlonly
*> Download SLASR + dependencies
*> <a href="http://www.netlib.org/cgi-bin/netlibfiles.tgz?format=tgz&filename=/lapack/lapack_routine/slasr.f">
*> [TGZ]</a>
*> <a href="http://www.netlib.org/cgi-bin/netlibfiles.zip?format=zip&filename=/lapack/lapack_routine/slasr.f">
*> [ZIP]</a>
*> <a href="http://www.netlib.org/cgi-bin/netlibfiles.txt?format=txt&filename=/lapack/lapack_routine/slasr.f">
*> [TXT]</a>
*> \endhtmlonly
*
*  Definition:
*  ===========
*
*       SUBROUTINE SLASR( SIDE, PIVOT, DIRECT, M, N, C, S, A, LDA )
*
*       .. Scalar Arguments ..
*       CHARACTER          DIRECT, PIVOT, SIDE
*       INTEGER            LDA, M, N
*       ..
*       .. Array Arguments ..
*       REAL               A( LDA, * ), C( * ), S( * )
*       ..
*
*
*> \par Purpose:
*  =============
*>
*> \verbatim
*>
*> SLASR applies a sequence of plane rotations to a real matrix A,
*> from either the left or the right.
*>
*> When SIDE = 'L', the transformation takes the form
*>
*>    A := P*A
*>
*> and when SIDE = 'R', the transformation takes the form
*>
*>    A := A*P**T
*>
*> where P is an orthogonal matrix consisting of a sequence of z plane
*> rotations, with z = M when SIDE = 'L' and z = N when SIDE = 'R',
*> and P**T is the transpose of P.
*>
*> When DIRECT = 'F' (Forward sequence), then
*>
*>    P = P(z-1) * ... * P(2) * P(1)
*>
*> and when DIRECT = 'B' (Backward sequence), then
*>
*>    P = P(1) * P(2) * ... * P(z-1)
*>
*> where P(k) is a plane rotation matrix defined by the 2-by-2 rotation
*>
*>    R(k) = (  c(k)  s(k) )
*>         = ( -s(k)  c(k) ).
*>
*> When PIVOT = 'V' (Variable pivot), the rotation is performed
*> for the plane (k,k+1), i.e., P(k) has the form
*>
*>    P(k) = (  1                                            )
*>           (       ...                                     )
*>           (              1                                )
*>           (                   c(k)  s(k)                  )
*>           (                  -s(k)  c(k)                  )
*>           (                                1              )
*>           (                                     ...       )
*>           (                                            1  )
*>
*> where R(k) appears as a rank-2 modification to the identity matrix in
*> rows and columns k and k+1.
*>
*> When PIVOT = 'T' (Top pivot), the rotation is performed for the
*> plane (1,k+1), so P(k) has the form
*>
*>    P(k) = (  c(k)                    s(k)                 )
*>           (         1                                     )
*>           (              ...                              )
*>           (                     1                         )
*>           ( -s(k)                    c(k)                 )
*>           (                                 1             )
*>           (                                      ...      )
*>           (                                             1 )
*>
*> where R(k) appears in rows and columns 1 and k+1.
*>
*> Similarly, when PIVOT = 'B' (Bottom pivot), the rotation is
*> performed for the plane (k,z), giving P(k) the form
*>
*>    P(k) = ( 1                                             )
*>           (      ...                                      )
*>           (             1                                 )
*>           (                  c(k)                    s(k) )
*>           (                         1                     )
*>           (                              ...              )
*>           (                                     1         )
*>           (                 -s(k)                    c(k) )
*>
*> where R(k) appears in rows and columns k and z.  The rotations are
*> performed without ever forming P(k) explicitly.
*> \endverbatim
*
*  Arguments:
*  ==========
*
*> \param[in] SIDE
*> \verbatim
*>          SIDE is CHARACTER*1
*>          Specifies whether the plane rotation matrix P is applied to
*>          A on the left or the right.
*>          = 'L':  Left, compute A := P*A
*>          = 'R':  Right, compute A:= A*P**T
*> \endverbatim
*>
*> \param[in] PIVOT
*> \verbatim
*>          PIVOT is CHARACTER*1
*>          Specifies the plane for which P(k) is a plane rotation
*>          matrix.
*>          = 'V':  Variable pivot, the plane (k,k+1)
*>          = 'T':  Top pivot, the plane (1,k+1)
*>          = 'B':  Bottom pivot, the plane (k,z)
*> \endverbatim
*>
*> \param[in] DIRECT
*> \verbatim
*>          DIRECT is CHARACTER*1
*>          Specifies whether P is a forward or backward sequence of
*>          plane rotations.
*>          = 'F':  Forward, P = P(z-1)*...*P(2)*P(1)
*>          = 'B':  Backward, P = P(1)*P(2)*...*P(z-1)
*> \endverbatim
*>
*> \param[in] M
*> \verbatim
*>          M is INTEGER
*>          The number of rows of the matrix A.  If m <= 1, an immediate
*>          return is effected.
*> \endverbatim
*>
*> \param[in] N
*> \verbatim
*>          N is INTEGER
*>          The number of columns of the matrix A.  If n <= 1, an
*>          immediate return is effected.
*> \endverbatim
*>
*> \param[in] C
*> \verbatim
*>          C is REAL array, dimension
*>                  (M-1) if SIDE = 'L'
*>                  (N-1) if SIDE = 'R'
*>          The cosines c(k) of the plane rotations.
*> \endverbatim
*>
*> \param[in] S
*> \verbatim
*>          S is REAL array, dimension
*>                  (M-1) if SIDE = 'L'
*>                  (N-1) if SIDE = 'R'
*>          The sines s(k) of the plane rotations.  The 2-by-2 plane
*>          rotation part of the matrix P(k), R(k), has the form
*>          R(k) = (  c(k)  s(k) )
*>                 ( -s(k)  c(k) ).
*> \endverbatim
*>
*> \param[in,out] A
*> \verbatim
*>          A is REAL array, dimension (LDA,N)
*>          The M-by-N matrix A.  On exit, A is overwritten by P*A if
*>          SIDE = 'R' or by A*P**T if SIDE = 'L'.
*> \endverbatim
*>
*> \param[in] LDA
*> \verbatim
*>          LDA is INTEGER
*>          The leading dimension of the array A.  LDA >= max(1,M).
*> \endverbatim
*
*  Authors:
*  ========
*
*> \author Univ. of Tennessee
*> \author Univ. of California Berkeley
*> \author Univ. of Colorado Denver
*> \author NAG Ltd.
*
*> \date December 2016
*
*> \ingroup OTHERauxiliary
*
*  =====================================================================
      SUBROUTINE SLASR( SIDE, PIVOT, DIRECT, M, N, C, S, A, LDA )
*
*  -- LAPACK auxiliary routine (version 3.7.0) --
*  -- LAPACK is a software package provided by Univ. of Tennessee,    --
*  -- Univ. of California Berkeley, Univ. of Colorado Denver and NAG Ltd..--
*     December 2016
*
*     .. Scalar Arguments ..
      CHARACTER          DIRECT, PIVOT, SIDE
      INTEGER            LDA, M, N
*     ..
*     .. Array Arguments ..
      REAL               A( LDA, * ), C( * ), S( * )
*     ..
*
*  =====================================================================
*
*     .. Parameters ..
      REAL               ONE, ZERO
      PARAMETER          ( ONE = 1.0E+0, ZERO = 0.0E+0 )
*     ..
*     .. Local Scalars ..
      INTEGER            I, INFO, J, L, P
      REAL               CTEMP, STEMP, TEMP
*     ..
*     .. External Functions ..
      LOGICAL            LSAME
      EXTERNAL           LSAME
*     ..
*     .. External Subroutines ..
      EXTERNAL           XERBLA
*     ..
*     .. Intrinsic Functions ..
      INTRINSIC          MAX
*     ..
*     .. Executable Statements ..
*
*     Test the input parameters
*
      INFO = 0
      IF( .NOT.( LSAME( SIDE, 'L' ) .OR. LSAME( SIDE, 'R' ) ) ) THEN
         INFO = 1
      ELSE IF( .NOT.( LSAME( PIVOT, 'V' ) .OR. LSAME( PIVOT,
     $         'T' ) .OR. LSAME( PIVOT, 'B' ) ) ) THEN
         INFO = 2
      ELSE IF( .NOT.( LSAME( DIRECT, 'F' ) .OR. LSAME( DIRECT, 'B' ) ) )
     $          THEN
         INFO = 3
      ELSE IF( M.LT.0 ) THEN
         INFO = 4
      ELSE IF( N.LT.0 ) THEN
         INFO = 5
      ELSE IF( LDA.LT.MAX( 1, M ) ) THEN
         INFO = 9
      END IF
      IF( INFO.NE.0 ) THEN
         CALL XERBLA( 'SLASR ', INFO )
         RETURN
      END IF
*
*     Quick return if possible
*
      IF( ( M.EQ.0 ) .OR. ( N.EQ.0 ) )
     $   RETURN
      IF( LSAME( SIDE, 'L' ) ) THEN
*
*        Form  P * A
*
         IF( LSAME( PIVOT, 'V' ) ) THEN
            IF( LSAME( DIRECT, 'F' ) ) THEN
               DO 20 J = 1, M - 1
                  CTEMP = C( J )
                  STEMP = S( J )
                  IF( ( CTEMP.NE.ONE ) .OR. ( STEMP.NE.ZERO ) ) THEN
                     L = N/8
                     P=0
                     DO 10 I = 1, L
                        P=P+1
                        TEMP = A( J+1, P )
                        A( J+1, P ) = CTEMP*TEMP - STEMP*A( J, P )
                        A( J, P ) = STEMP*TEMP + CTEMP*A( J, P )

                        P=P+1
                        TEMP = A( J+1, P )
                        A( J+1, P ) = CTEMP*TEMP - STEMP*A( J, P )
                        A( J, P ) = STEMP*TEMP + CTEMP*A( J, P )

                        P=P+1
                        TEMP = A( J+1, P )
                        A( J+1, P ) = CTEMP*TEMP - STEMP*A( J, P )
                        A( J, P ) = STEMP*TEMP + CTEMP*A( J, P )

                        P=P+1
                        TEMP = A( J+1, P )
                        A( J+1, P ) = CTEMP*TEMP - STEMP*A( J, P )
                        A( J, P ) = STEMP*TEMP + CTEMP*A( J, P )

                        P=P+1
                        TEMP = A( J+1, P )
                        A( J+1, P ) = CTEMP*TEMP - STEMP*A( J, P )
                        A( J, P ) = STEMP*TEMP + CTEMP*A( J, P )

                        P=P+1
                        TEMP = A( J+1, P )
                        A( J+1, P ) = CTEMP*TEMP - STEMP*A( J, P )
                        A( J, P ) = STEMP*TEMP + CTEMP*A( J, P )

                        P=P+1
                        TEMP = A( J+1, P )
                        A( J+1, P ) = CTEMP*TEMP - STEMP*A( J, P )
                        A( J, P ) = STEMP*TEMP + CTEMP*A( J, P )

                        P=P+1
                        TEMP = A( J+1, P )
                        A( J+1, P ) = CTEMP*TEMP - STEMP*A( J, P )
                        A( J, P ) = STEMP*TEMP + CTEMP*A( J, P )
   10                CONTINUE
                     L = MOD(N,8)
                     DO 11 I = N-L+1, N
                        TEMP = A( J+1, I )
                        A( J+1, I ) = CTEMP*TEMP - STEMP*A( J, I )
                        A( J, I ) = STEMP*TEMP + CTEMP*A( J, I )
   11                CONTINUE 
                  END IF
   20          CONTINUE
            ELSE IF( LSAME( DIRECT, 'B' ) ) THEN
               DO 40 J = M - 1, 1, -1
                  CTEMP = C( J )
                  STEMP = S( J )
                  IF( ( CTEMP.NE.ONE ) .OR. ( STEMP.NE.ZERO ) ) THEN
                     L = N/8
                     P=0
                     DO 30 I = 1, L
                        P=P+1
                        TEMP = A( J+1, P )
                        A( J+1, P ) = CTEMP*TEMP - STEMP*A( J, P )
                        A( J, P ) = STEMP*TEMP + CTEMP*A( J, P )

                        P=P+1
                        TEMP = A( J+1, P )
                        A( J+1, P ) = CTEMP*TEMP - STEMP*A( J, P )
                        A( J, P ) = STEMP*TEMP + CTEMP*A( J, P )

                        P=P+1
                        TEMP = A( J+1, P )
                        A( J+1, P ) = CTEMP*TEMP - STEMP*A( J, P )
                        A( J, P ) = STEMP*TEMP + CTEMP*A( J, P )

                        P=P+1
                        TEMP = A( J+1, P )
                        A( J+1, P ) = CTEMP*TEMP - STEMP*A( J, P )
                        A( J, P ) = STEMP*TEMP + CTEMP*A( J, P )

                        P=P+1
                        TEMP = A( J+1, P )
                        A( J+1, P ) = CTEMP*TEMP - STEMP*A( J, P )
                        A( J, P ) = STEMP*TEMP + CTEMP*A( J, P )

                        P=P+1
                        TEMP = A( J+1, P )
                        A( J+1, P ) = CTEMP*TEMP - STEMP*A( J, P )
                        A( J, P ) = STEMP*TEMP + CTEMP*A( J, P )

                        P=P+1
                        TEMP = A( J+1, P )
                        A( J+1, P ) = CTEMP*TEMP - STEMP*A( J, P )
                        A( J, P ) = STEMP*TEMP + CTEMP*A( J, P )

                        P=P+1
                        TEMP = A( J+1, P )
                        A( J+1, P ) = CTEMP*TEMP - STEMP*A( J, P )
                        A( J, P ) = STEMP*TEMP + CTEMP*A( J, P )
   30                CONTINUE
                     L = MOD(N,8)
                     DO 31 I = N-L+1, N
                         TEMP = A( J+1, I )
                        A( J+1, I ) = CTEMP*TEMP - STEMP*A( J, I )
                        A( J, I ) = STEMP*TEMP + CTEMP*A( J, I )
   31                CONTINUE 
                  END IF
   40          CONTINUE
            END IF
         ELSE IF( LSAME( PIVOT, 'T' ) ) THEN
            IF( LSAME( DIRECT, 'F' ) ) THEN
               DO 60 J = 2, M
                  CTEMP = C( J-1 )
                  STEMP = S( J-1 )
                  IF( ( CTEMP.NE.ONE ) .OR. ( STEMP.NE.ZERO ) ) THEN
                     L = N/8
                     P=0
                     DO 50 I = 1, L
                        P=P+1
                        TEMP = A( J, P )
                        A( J, P ) = CTEMP*TEMP - STEMP*A( 1, P )
                        A( 1, P ) = STEMP*TEMP + CTEMP*A( 1, P )
                        P=P+1
                        TEMP = A( J, P )
                        A( J, P ) = CTEMP*TEMP - STEMP*A( 1, P )
                        A( 1, P ) = STEMP*TEMP + CTEMP*A( 1, P )
                        P=P+1
                        TEMP = A( J, P )
                        A( J, P ) = CTEMP*TEMP - STEMP*A( 1, P )
                        A( 1, P ) = STEMP*TEMP + CTEMP*A( 1, P )
                        P=P+1
                        TEMP = A( J, P )
                        A( J, P ) = CTEMP*TEMP - STEMP*A( 1, P )
                        A( 1, P ) = STEMP*TEMP + CTEMP*A( 1, P )
                        P=P+1
                        TEMP = A( J, P )
                        A( J, P ) = CTEMP*TEMP - STEMP*A( 1, P )
                        A( 1, P ) = STEMP*TEMP + CTEMP*A( 1, P )
                        P=P+1
                        TEMP = A( J, P )
                        A( J, P ) = CTEMP*TEMP - STEMP*A( 1, P )
                        A( 1, P ) = STEMP*TEMP + CTEMP*A( 1, P )
                        P=P+1
                        TEMP = A( J, P )
                        A( J, P ) = CTEMP*TEMP - STEMP*A( 1, P )
                        A( 1, P ) = STEMP*TEMP + CTEMP*A( 1, P )
                        P=P+1
                        TEMP = A( J, P )
                        A( J, P ) = CTEMP*TEMP - STEMP*A( 1, P )
                        A( 1, P ) = STEMP*TEMP + CTEMP*A( 1, P )
   50                CONTINUE
                     L = MOD(N,8)
                     DO 51 I = N-L+1, N
                        TEMP = A( J, I )
                        A( J, I ) = CTEMP*TEMP - STEMP*A( 1, I )
                        A( 1, I ) = STEMP*TEMP + CTEMP*A( 1, I ) 
   51                CONTINUE
                  END IF
   60          CONTINUE
            ELSE IF( LSAME( DIRECT, 'B' ) ) THEN
               DO 80 J = M, 2, -1
                  CTEMP = C( J-1 )
                  STEMP = S( J-1 )
                  IF( ( CTEMP.NE.ONE ) .OR. ( STEMP.NE.ZERO ) ) THEN
                     L = N/8
                     P=0
                     DO 70 I = 1, L
                        P=P+1
                        TEMP = A( J, P )
                        A( J, P ) = CTEMP*TEMP - STEMP*A( 1, P )
                        A( 1, P ) = STEMP*TEMP + CTEMP*A( 1, P )
                        P=P+1
                        TEMP = A( J, P )
                        A( J, P ) = CTEMP*TEMP - STEMP*A( 1, P )
                        A( 1, P ) = STEMP*TEMP + CTEMP*A( 1, P )
                        P=P+1
                        TEMP = A( J, P )
                        A( J, P ) = CTEMP*TEMP - STEMP*A( 1, P )
                        A( 1, P ) = STEMP*TEMP + CTEMP*A( 1, P )
                        P=P+1
                        TEMP = A( J, P )
                        A( J, P ) = CTEMP*TEMP - STEMP*A( 1, P )
                        A( 1, P ) = STEMP*TEMP + CTEMP*A( 1, P )
                        P=P+1
                        TEMP = A( J, P )
                        A( J, P ) = CTEMP*TEMP - STEMP*A( 1, P )
                        A( 1, P ) = STEMP*TEMP + CTEMP*A( 1, P )
                        P=P+1
                        TEMP = A( J, P )
                        A( J, P ) = CTEMP*TEMP - STEMP*A( 1, P )
                        A( 1, P ) = STEMP*TEMP + CTEMP*A( 1, P )
                        P=P+1
                        TEMP = A( J, P )
                        A( J, P ) = CTEMP*TEMP - STEMP*A( 1, P )
                        A( 1, P ) = STEMP*TEMP + CTEMP*A( 1, P )
                        P=P+1
                        TEMP = A( J, P )
                        A( J, P ) = CTEMP*TEMP - STEMP*A( 1, P )
                        A( 1, P ) = STEMP*TEMP + CTEMP*A( 1, P )
   70                CONTINUE
                     L = MOD(N,8)
                     DO 71 I = N-L+1, N
                        TEMP = A( J, I )
                        A( J, I ) = CTEMP*TEMP - STEMP*A( 1, I )
                        A( 1, I ) = STEMP*TEMP + CTEMP*A( 1, I ) 
   71                CONTINUE
                  END IF
   80          CONTINUE
            END IF
         ELSE IF( LSAME( PIVOT, 'B' ) ) THEN
            IF( LSAME( DIRECT, 'F' ) ) THEN
               DO 100 J = 1, M - 1
                  CTEMP = C( J )
                  STEMP = S( J )
                  IF( ( CTEMP.NE.ONE ) .OR. ( STEMP.NE.ZERO ) ) THEN
                     L = N/8
                     P=0
                     DO 90 I = 1, L
                        P=P+1
                        TEMP = A( J, P )
                        A( J, P ) = STEMP*A( M, P ) + CTEMP*TEMP
                        A( M, P ) = CTEMP*A( M, P ) - STEMP*TEMP
                        P=P+1
                        TEMP = A( J, P )
                        A( J, P ) = STEMP*A( M, P ) + CTEMP*TEMP
                        A( M, P ) = CTEMP*A( M, P ) - STEMP*TEMP
                        P=P+1
                        TEMP = A( J, P )
                        A( J, P ) = STEMP*A( M, P ) + CTEMP*TEMP
                        A( M, P ) = CTEMP*A( M, P ) - STEMP*TEMP
                        P=P+1
                        TEMP = A( J, P )
                        A( J, P ) = STEMP*A( M, P ) + CTEMP*TEMP
                        A( M, P ) = CTEMP*A( M, P ) - STEMP*TEMP
                        P=P+1
                        TEMP = A( J, P )
                        A( J, P ) = STEMP*A( M, P ) + CTEMP*TEMP
                        A( M, P ) = CTEMP*A( M, P ) - STEMP*TEMP
                        P=P+1
                        TEMP = A( J, P )
                        A( J, P ) = STEMP*A( M, P ) + CTEMP*TEMP
                        A( M, P ) = CTEMP*A( M, P ) - STEMP*TEMP
                        P=P+1
                        TEMP = A( J, P )
                        A( J, P ) = STEMP*A( M, P ) + CTEMP*TEMP
                        A( M, P ) = CTEMP*A( M, P ) - STEMP*TEMP
                        P=P+1
                        TEMP = A( J, P )
                        A( J, P ) = STEMP*A( M, P ) + CTEMP*TEMP
                        A( M, P ) = CTEMP*A( M, P ) - STEMP*TEMP
   90                CONTINUE
                     L = MOD(N,8)
                     DO 91 I = N-L+1, N
                        TEMP = A( J, I )
                        A( J, I ) = STEMP*A( M, I ) + CTEMP*TEMP
                        A( M, I ) = CTEMP*A( M, I ) - STEMP*TEMP
   91                CONTINUE 
                  END IF
  100          CONTINUE
            ELSE IF( LSAME( DIRECT, 'B' ) ) THEN
               DO 120 J = M - 1, 1, -1
                  CTEMP = C( J )
                  STEMP = S( J )
                  IF( ( CTEMP.NE.ONE ) .OR. ( STEMP.NE.ZERO ) ) THEN
                     L = N/8
                     P=0
                     DO 110 I = 1, L
                        P=P+1
                        TEMP = A( J, P )
                        A( J, P ) = STEMP*A( M, P ) + CTEMP*TEMP
                        A( M, P ) = CTEMP*A( M, P ) - STEMP*TEMP
                        P=P+1
                        TEMP = A( J, P )
                        A( J, P ) = STEMP*A( M, P ) + CTEMP*TEMP
                        A( M, P ) = CTEMP*A( M, P ) - STEMP*TEMP
                        P=P+1
                        TEMP = A( J, P )
                        A( J, P ) = STEMP*A( M, P ) + CTEMP*TEMP
                        A( M, P ) = CTEMP*A( M, P ) - STEMP*TEMP
                        P=P+1
                        TEMP = A( J, P )
                        A( J, P ) = STEMP*A( M, P ) + CTEMP*TEMP
                        A( M, P ) = CTEMP*A( M, P ) - STEMP*TEMP
                        P=P+1
                        TEMP = A( J, P )
                        A( J, P ) = STEMP*A( M, P ) + CTEMP*TEMP
                        A( M, P ) = CTEMP*A( M, P ) - STEMP*TEMP
                        P=P+1
                        TEMP = A( J, P )
                        A( J, P ) = STEMP*A( M, P ) + CTEMP*TEMP
                        A( M, P ) = CTEMP*A( M, P ) - STEMP*TEMP
                        P=P+1
                        TEMP = A( J, P )
                        A( J, P ) = STEMP*A( M, P ) + CTEMP*TEMP
                        A( M, P ) = CTEMP*A( M, P ) - STEMP*TEMP
                        P=P+1
                        TEMP = A( J, P )
                        A( J, P ) = STEMP*A( M, P ) + CTEMP*TEMP
                        A( M, P ) = CTEMP*A( M, P ) - STEMP*TEMP
  110                CONTINUE
                     L = MOD(N,8)
                     DO 111 I = N-L+1, N
                        TEMP = A( J, I )
                        A( J, I ) = STEMP*A( M, I ) + CTEMP*TEMP
                        A( M, I ) = CTEMP*A( M, I ) - STEMP*TEMP
  111                CONTINUE 
                  END IF
  120          CONTINUE
            END IF
         END IF
      ELSE IF( LSAME( SIDE, 'R' ) ) THEN
*
*        Form A * P**T
*
         IF( LSAME( PIVOT, 'V' ) ) THEN
            IF( LSAME( DIRECT, 'F' ) ) THEN
               DO 140 J = 1, N - 1
                  CTEMP = C( J )
                  STEMP = S( J )
                  IF( ( CTEMP.NE.ONE ) .OR. ( STEMP.NE.ZERO ) ) THEN
                     L = M/8
                     P=0
                     DO 130 I = 1, L
                        P=P+1
                        TEMP = A( P, J+1 )
                        A( P, J+1 ) = CTEMP*TEMP - STEMP*A( P, J )
                        A( P, J ) = STEMP*TEMP + CTEMP*A( P, J )
                        P=P+1
                        TEMP = A( P, J+1 )
                        A( P, J+1 ) = CTEMP*TEMP - STEMP*A( P, J )
                        A( P, J ) = STEMP*TEMP + CTEMP*A( P, J )
                        P=P+1
                        TEMP = A( P, J+1 )
                        A( P, J+1 ) = CTEMP*TEMP - STEMP*A( P, J )
                        A( P, J ) = STEMP*TEMP + CTEMP*A( P, J )
                        P=P+1
                        TEMP = A( P, J+1 )
                        A( P, J+1 ) = CTEMP*TEMP - STEMP*A( P, J )
                        A( P, J ) = STEMP*TEMP + CTEMP*A( P, J )
                        P=P+1
                        TEMP = A( P, J+1 )
                        A( P, J+1 ) = CTEMP*TEMP - STEMP*A( P, J )
                        A( P, J ) = STEMP*TEMP + CTEMP*A( P, J )
                        P=P+1
                        TEMP = A( P, J+1 )
                        A( P, J+1 ) = CTEMP*TEMP - STEMP*A( P, J )
                        A( P, J ) = STEMP*TEMP + CTEMP*A( P, J )
                        P=P+1
                        TEMP = A( P, J+1 )
                        A( P, J+1 ) = CTEMP*TEMP - STEMP*A( P, J )
                        A( P, J ) = STEMP*TEMP + CTEMP*A( P, J )
                        P=P+1
                        TEMP = A( P, J+1 )
                        A( P, J+1 ) = CTEMP*TEMP - STEMP*A( P, J )
                        A( P, J ) = STEMP*TEMP + CTEMP*A( P, J )
  130                CONTINUE
                     L = MOD(M,8)
                     DO 131 I = M-L+1, M
                        TEMP = A( I, J+1 )
                        A( I, J+1 ) = CTEMP*TEMP - STEMP*A( I, J )
                        A( I, J ) = STEMP*TEMP + CTEMP*A( I, J ) 
  131                CONTINUE
                  END IF
  140          CONTINUE
            ELSE IF( LSAME( DIRECT, 'B' ) ) THEN
               DO 160 J = N - 1, 1, -1
                  CTEMP = C( J )
                  STEMP = S( J )
                  IF( ( CTEMP.NE.ONE ) .OR. ( STEMP.NE.ZERO ) ) THEN
                     L = M/8
                     P=0
                     DO 150 I = 1, L
                        P=P+1
                        TEMP = A( P, J+1 )
                        A( P, J+1 ) = CTEMP*TEMP - STEMP*A( P, J )
                        A( P, J ) = STEMP*TEMP + CTEMP*A( P, J )
                        P=P+1
                        TEMP = A( P, J+1 )
                        A( P, J+1 ) = CTEMP*TEMP - STEMP*A( P, J )
                        A( P, J ) = STEMP*TEMP + CTEMP*A( P, J )
                        P=P+1
                        TEMP = A( P, J+1 )
                        A( P, J+1 ) = CTEMP*TEMP - STEMP*A( P, J )
                        A( P, J ) = STEMP*TEMP + CTEMP*A( P, J )
                        P=P+1
                        TEMP = A( P, J+1 )
                        A( P, J+1 ) = CTEMP*TEMP - STEMP*A( P, J )
                        A( P, J ) = STEMP*TEMP + CTEMP*A( P, J )
                        P=P+1
                        TEMP = A( P, J+1 )
                        A( P, J+1 ) = CTEMP*TEMP - STEMP*A( P, J )
                        A( P, J ) = STEMP*TEMP + CTEMP*A( P, J )
                        P=P+1
                        TEMP = A( P, J+1 )
                        A( P, J+1 ) = CTEMP*TEMP - STEMP*A( P, J )
                        A( P, J ) = STEMP*TEMP + CTEMP*A( P, J )
                        P=P+1
                        TEMP = A( P, J+1 )
                        A( P, J+1 ) = CTEMP*TEMP - STEMP*A( P, J )
                        A( P, J ) = STEMP*TEMP + CTEMP*A( P, J )
                        P=P+1
                        TEMP = A( P, J+1 )
                        A( P, J+1 ) = CTEMP*TEMP - STEMP*A( P, J )
                        A( P, J ) = STEMP*TEMP + CTEMP*A( P, J )
  150                CONTINUE
                     L = MOD(M,8)
                     DO 151 I = M-L+1, M
                        TEMP = A( I, J+1 )
                        A( I, J+1 ) = CTEMP*TEMP - STEMP*A( I, J )
                        A( I, J ) = STEMP*TEMP + CTEMP*A( I, J ) 
  151                CONTINUE
                  END IF
  160          CONTINUE
            END IF
         ELSE IF( LSAME( PIVOT, 'T' ) ) THEN
            IF( LSAME( DIRECT, 'F' ) ) THEN
               DO 180 J = 2, N
                  CTEMP = C( J-1 )
                  STEMP = S( J-1 )
                  IF( ( CTEMP.NE.ONE ) .OR. ( STEMP.NE.ZERO ) ) THEN
                     L = M/8
                     P=0
                     DO 170 I = 1, L
                        P=P+1
                        TEMP = A( P, J )
                        A( P, J ) = CTEMP*TEMP - STEMP*A( P, 1 )
                        A( P, 1 ) = STEMP*TEMP + CTEMP*A( P, 1 )
                        P=P+1
                        TEMP = A( P, J )
                        A( P, J ) = CTEMP*TEMP - STEMP*A( P, 1 )
                        A( P, 1 ) = STEMP*TEMP + CTEMP*A( P, 1 )
                        P=P+1
                        TEMP = A( P, J )
                        A( P, J ) = CTEMP*TEMP - STEMP*A( P, 1 )
                        A( P, 1 ) = STEMP*TEMP + CTEMP*A( P, 1 )
                        P=P+1
                        TEMP = A( P, J )
                        A( P, J ) = CTEMP*TEMP - STEMP*A( P, 1 )
                        A( P, 1 ) = STEMP*TEMP + CTEMP*A( P, 1 )
                        P=P+1
                        TEMP = A( P, J )
                        A( P, J ) = CTEMP*TEMP - STEMP*A( P, 1 )
                        A( P, 1 ) = STEMP*TEMP + CTEMP*A( P, 1 )
                        P=P+1
                        TEMP = A( P, J )
                        A( P, J ) = CTEMP*TEMP - STEMP*A( P, 1 )
                        A( P, 1 ) = STEMP*TEMP + CTEMP*A( P, 1 )
                        P=P+1
                        TEMP = A( P, J )
                        A( P, J ) = CTEMP*TEMP - STEMP*A( P, 1 )
                        A( P, 1 ) = STEMP*TEMP + CTEMP*A( P, 1 )
                        P=P+1
                        TEMP = A( P, J )
                        A( P, J ) = CTEMP*TEMP - STEMP*A( P, 1 )
                        A( P, 1 ) = STEMP*TEMP + CTEMP*A( P, 1 )
  170                CONTINUE
                     L = MOD(M,8)
                     DO 171 I = M-L+1, M
                        TEMP = A( I, J )
                        A( I, J ) = CTEMP*TEMP - STEMP*A( I, 1 )
                        A( I, 1 ) = STEMP*TEMP + CTEMP*A( I, 1 ) 
  171                CONTINUE  
                  END IF
  180          CONTINUE
            ELSE IF( LSAME( DIRECT, 'B' ) ) THEN
               DO 200 J = N, 2, -1
                  CTEMP = C( J-1 )
                  STEMP = S( J-1 )
                  IF( ( CTEMP.NE.ONE ) .OR. ( STEMP.NE.ZERO ) ) THEN
                     L = M/8
                     P=0
                     DO 190 I = 1, L
                        P=P+1
                        TEMP = A( P, J )
                        A( P, J ) = CTEMP*TEMP - STEMP*A( P, 1 )
                        A( P, 1 ) = STEMP*TEMP + CTEMP*A( P, 1 )
                        P=P+1
                        TEMP = A( P, J )
                        A( P, J ) = CTEMP*TEMP - STEMP*A( P, 1 )
                        A( P, 1 ) = STEMP*TEMP + CTEMP*A( P, 1 )
                        P=P+1
                        TEMP = A( P, J )
                        A( P, J ) = CTEMP*TEMP - STEMP*A( P, 1 )
                        A( P, 1 ) = STEMP*TEMP + CTEMP*A( P, 1 )
                        P=P+1
                        TEMP = A( P, J )
                        A( P, J ) = CTEMP*TEMP - STEMP*A( P, 1 )
                        A( P, 1 ) = STEMP*TEMP + CTEMP*A( P, 1 )
                        P=P+1
                        TEMP = A( P, J )
                        A( P, J ) = CTEMP*TEMP - STEMP*A( P, 1 )
                        A( P, 1 ) = STEMP*TEMP + CTEMP*A( P, 1 )
                        P=P+1
                        TEMP = A( P, J )
                        A( P, J ) = CTEMP*TEMP - STEMP*A( P, 1 )
                        A( P, 1 ) = STEMP*TEMP + CTEMP*A( P, 1 )
                        P=P+1
                        TEMP = A( P, J )
                        A( P, J ) = CTEMP*TEMP - STEMP*A( P, 1 )
                        A( P, 1 ) = STEMP*TEMP + CTEMP*A( P, 1 )
                        P=P+1
                        TEMP = A( P, J )
                        A( P, J ) = CTEMP*TEMP - STEMP*A( P, 1 )
                        A( P, 1 ) = STEMP*TEMP + CTEMP*A( P, 1 )
  190                CONTINUE
                     L = MOD(M,8)
                     DO 191 I = M-L+1, M
                        TEMP = A( I, J )
                        A( I, J ) = CTEMP*TEMP - STEMP*A( I, 1 )
                        A( I, 1 ) = STEMP*TEMP + CTEMP*A( I, 1 ) 
  191                CONTINUE  
                  END IF
  200          CONTINUE
            END IF
         ELSE IF( LSAME( PIVOT, 'B' ) ) THEN
            IF( LSAME( DIRECT, 'F' ) ) THEN
               DO 220 J = 1, N - 1
                  CTEMP = C( J )
                  STEMP = S( J )
                  IF( ( CTEMP.NE.ONE ) .OR. ( STEMP.NE.ZERO ) ) THEN
                    L = M/8
                    P=0
                    DO 210 I = 1, L
                        P=P+1
                        TEMP = A( P, J )
                        A( P, J ) = STEMP*A( P, N ) + CTEMP*TEMP
                        A( P, N ) = CTEMP*A( P, N ) - STEMP*TEMP
                        P=P+1
                        TEMP = A( P, J )
                        A( P, J ) = STEMP*A( P, N ) + CTEMP*TEMP
                        A( P, N ) = CTEMP*A( P, N ) - STEMP*TEMP
                        P=P+1
                        TEMP = A( P, J )
                        A( P, J ) = STEMP*A( P, N ) + CTEMP*TEMP
                        A( P, N ) = CTEMP*A( P, N ) - STEMP*TEMP
                        P=P+1
                        TEMP = A( P, J )
                        A( P, J ) = STEMP*A( P, N ) + CTEMP*TEMP
                        A( P, N ) = CTEMP*A( P, N ) - STEMP*TEMP
                        P=P+1
                        TEMP = A( P, J )
                        A( P, J ) = STEMP*A( P, N ) + CTEMP*TEMP
                        A( P, N ) = CTEMP*A( P, N ) - STEMP*TEMP
                        P=P+1
                        TEMP = A( P, J )
                        A( P, J ) = STEMP*A( P, N ) + CTEMP*TEMP
                        A( P, N ) = CTEMP*A( P, N ) - STEMP*TEMP
                        P=P+1
                        TEMP = A( P, J )
                        A( P, J ) = STEMP*A( P, N ) + CTEMP*TEMP
                        A( P, N ) = CTEMP*A( P, N ) - STEMP*TEMP
                        P=P+1
                        TEMP = A( P, J )
                        A( P, J ) = STEMP*A( P, N ) + CTEMP*TEMP
                        A( P, N ) = CTEMP*A( P, N ) - STEMP*TEMP
  210                CONTINUE
                     L = MOD(M,8)
                     DO 211 I = M-L+1, M
                        TEMP = A( I, J )
                        A( I, J ) = STEMP*A( I, N ) + CTEMP*TEMP
                        A( I, N ) = CTEMP*A( I, N ) - STEMP*TEMP
  211                CONTINUE
                  END IF
  220          CONTINUE
            ELSE IF( LSAME( DIRECT, 'B' ) ) THEN
               DO 240 J = N - 1, 1, -1
                  CTEMP = C( J )
                  STEMP = S( J )
                  IF( ( CTEMP.NE.ONE ) .OR. ( STEMP.NE.ZERO ) ) THEN
                    L = M/8
                    P=0
                    DO 230 I = 1, L
                        P=P+1
                        TEMP = A( P, J )
                        A( P, J ) = STEMP*A( P, N ) + CTEMP*TEMP
                        A( P, N ) = CTEMP*A( P, N ) - STEMP*TEMP
                        P=P+1
                        TEMP = A( P, J )
                        A( P, J ) = STEMP*A( P, N ) + CTEMP*TEMP
                        A( P, N ) = CTEMP*A( P, N ) - STEMP*TEMP
                        P=P+1
                        TEMP = A( P, J )
                        A( P, J ) = STEMP*A( P, N ) + CTEMP*TEMP
                        A( P, N ) = CTEMP*A( P, N ) - STEMP*TEMP
                        P=P+1
                        TEMP = A( P, J )
                        A( P, J ) = STEMP*A( P, N ) + CTEMP*TEMP
                        A( P, N ) = CTEMP*A( P, N ) - STEMP*TEMP
                        P=P+1
                        TEMP = A( P, J )
                        A( P, J ) = STEMP*A( P, N ) + CTEMP*TEMP
                        A( P, N ) = CTEMP*A( P, N ) - STEMP*TEMP
                        P=P+1
                        TEMP = A( P, J )
                        A( P, J ) = STEMP*A( P, N ) + CTEMP*TEMP
                        A( P, N ) = CTEMP*A( P, N ) - STEMP*TEMP
                        P=P+1
                        TEMP = A( P, J )
                        A( P, J ) = STEMP*A( P, N ) + CTEMP*TEMP
                        A( P, N ) = CTEMP*A( P, N ) - STEMP*TEMP
                        P=P+1
                        TEMP = A( P, J )
                        A( P, J ) = STEMP*A( P, N ) + CTEMP*TEMP
                        A( P, N ) = CTEMP*A( P, N ) - STEMP*TEMP
  230                CONTINUE
                     L = MOD(M,8)
                     DO 231 I = M-L+1, M
                        TEMP = A( I, J )
                        A( I, J ) = STEMP*A( I, N ) + CTEMP*TEMP
                        A( I, N ) = CTEMP*A( I, N ) - STEMP*TEMP
  231                CONTINUE
                  END IF
  240          CONTINUE
            END IF
         END IF
      END IF
*
      RETURN
*
*     End of SLASR
*
      END
