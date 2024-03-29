#
# The contents of this file are subject to the Mozilla Public
# License Version 1.1 (the "License"); you may not use this file
# except in compliance with the License. You may obtain a copy
# of the License at http://www.mozilla.org/MPL/
#
# Software distributed under the License is distributed on an
# "AS IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or
# implied. See the License for the specific language governing
# rights and limitations under the License.
#
# The Original Code is State Machine Compiler (SMC).
#
# The Initial Developer of the Original Code is Charles W. Rapp.
# Portions created by Charles W. Rapp are
# Copyright (C) 2000 - 2007. Charles W. Rapp.
# All Rights Reserved.
#
# Contributor(s):
#       Port to Ruby by Francois Perrad, francois.perrad@gadz.org
#
# RCS ID
# $Id: Makefile,v 1.4 2007/01/15 16:58:58 cwrapp Exp $
#
# CHANGE LOG
# (See the bottom of this file.)
#

#################################################################
# Macros.
#

SM_SOURCES=     AppClass.sm
SOURCES=        $(SM_SOURCES:%.sm=%_sm.rb)

# Uncomment to turn on reflection.
# REFLECT = 	-reflect

SMC=            java -jar ../../../bin/Smc.jar
SMC_FLAGS=      -ruby -g $(REFLECT)

#################################################################
# Rules.
#

%_sm.rb : %.sm
		$(SMC) $(SMC_FLAGS) $<

all :           checkstring test

checkstring :   $(SOURCES)

clean :
		-rm *_sm.rb

test:
		-ruby -I ../../../lib/Ruby -w checkstring.rb ""
		-ruby -I ../../../lib/Ruby -w checkstring.rb 00
		-ruby -I ../../../lib/Ruby -w checkstring.rb 1c
		-ruby -I ../../../lib/Ruby -w checkstring.rb c0
		-ruby -I ../../../lib/Ruby -w checkstring.rb abcba
		-ruby -I ../../../lib/Ruby -w checkstring.rb 110010c010011
		-ruby -I ../../../lib/Ruby -w checkstring.rb 110010c110010

#
# CHANGE LOG
# $Log: Makefile,v $
# Revision 1.4  2007/01/15 16:58:58  cwrapp
# Release 4.4.0 second commit.
#
# Revision 1.3  2007/01/03 14:43:24  fperrad
# + Added -reflect option for Perl, Python and Ruby code generation
#
# Revision 1.2  2006/09/17 16:26:06  cwrapp
# Initial v. 4.3.3 check-in.
#
# Revision 1.1  2005/06/16 17:52:03  fperrad
# Added Ruby examples 1 - 4 and 7.
#