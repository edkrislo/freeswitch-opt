# 
# The contents of this file are subject to the Mozilla Public
# License Version 1.1 (the "License"); you may not use this file
# except in compliance with the License. You may obtain a copy of
# the License at http://www.mozilla.org/MPL/
# 
# Software distributed under the License is distributed on an "AS
# IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or
# implied. See the License for the specific language governing
# rights and limitations under the License.
# 
# The Original Code is State Machine Compiler (SMC).
# 
# The Initial Developer of the Original Code is Charles W. Rapp.
# Portions created by Charles W. Rapp are
# Copyright (C) 2000 Charles W. Rapp.
# All Rights Reserved.
# 
# Contributor(s):
#
# RCS ID
# $Id: Makefile,v 1.5 2007/01/15 16:58:56 cwrapp Exp $
#
# CHANGE LOG
# $Log: Makefile,v $
# Revision 1.5  2007/01/15 16:58:56  cwrapp
# Release 4.4.0 second commit.
#
# Revision 1.4  2005/05/28 13:31:18  cwrapp
# Updated C++ examples.
#
# Revision 1.0  2003/12/14 19:32:19  charlesr
# Initial revision
#

TARGET    = sleeper

CXX       = c++
CPPFLAGS  = -g -I../../../lib
SMC       = java -jar ../../../bin/Smc.jar
SMCFLAGS  = -c++ -g

FSMS      = AppClass.sm
SOURCES   = $(FSMS:.sm=_sm.cpp) AppClass.cpp Main.cpp
HEADERS   = $(FSMS:.sm=_sm.h) AppClass.h
OBJECTS   = $(SOURCES:.cpp=.o)

##############

%_sm.h %_sm.cpp : %.sm
	$(SMC) $(SMCFLAGS) $<

all	: $(TARGET) test

$(TARGET) : $(HEADERS) $(SOURCES)
	$(CXX) $(CPPFLAGS) -o $@ $(SOURCES)

test	: $(TARGET)
	$(TARGET)

clean :
	rm -f $(TARGET) $(OBJECTS) *_sm.h *_sm.cpp
