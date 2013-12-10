--
--  This file is part of the OpenLink Software Virtuoso Open-Source (VOS)
--  project.
--
--  Copyright (C) 1998-2013 OpenLink Software
--
--  This project is free software; you can redistribute it and/or modify it
--  under the terms of the GNU General Public License as published by the
--  Free Software Foundation; only version 2 of the License, dated June 1991.
--
--  This program is distributed in the hope that it will be useful, but
--  WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
--  General Public License for more details.
--
--  You should have received a copy of the GNU General Public License along
--  with this program; if not, write to the Free Software Foundation, Inc.,
--  51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
--
--
changequote([, ])

define(ok, [$1;
ECHO BOTH $IF $EQU $STATE "OK" "PASSED:" "***FAILED:";
ECHO BOTH $2 ": \"" $STATE "\"\t (must be OK)\n";]);
define(val, [$1;
ECHO BOTH $IF $EQU $STATE "OK" "PASSED:" "***FAILED:";
ECHO BOTH $3 ": \"" $STATE "\"\t (must be OK)\n";
ECHO BOTH $IF $EQU $LAST[[1]] $2 "PASSED:" "***FAILED:";
ECHO BOTH $3 ": \"" $LAST[[1]] "\"\t (must be: " $2 ")\n";]);
define(valgt, [$1;
ECHO BOTH $IF $EQU $STATE "OK" "PASSED:" "***FAILED:";
ECHO BOTH $3 ": \"" $STATE "\"\t (must be OK)\n";
ECHO BOTH $IF $GT $LAST[[1]] $2 "PASSED:" "***FAILED:";
ECHO BOTH $3 ": \"" $LAST[[1]] "\"\t (must be greater than " $2 ")\n";]);
define(vallt, [$1;
ECHO BOTH $IF $EQU $STATE "OK" "PASSED:" "***FAILED:";
ECHO BOTH $3 ": \"" $STATE "\"\t (must be OK)\n";
ECHO BOTH $IF $GT $2 $LAST[[1]] "PASSED:" "***FAILED:";
ECHO BOTH $3 ": \"" $LAST[[1]] "\"\t (must be less than " $2 ")\n";]);
define(val0, [$1;
ECHO BOTH $2 ": \"" $LAST[[1]] "\n";])

-- Autogenerated test script
