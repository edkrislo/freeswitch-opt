//
// The contents of this file are subject to the Mozilla Public
// License Version 1.1 (the "License"); you may not use this file
// except in compliance with the License. You may obtain a copy of
// the License at http://www.mozilla.org/MPL/
// 
// Software distributed under the License is distributed on an "AS
// IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or
// implied. See the License for the specific language governing
// rights and limitations under the License.
// 
// The Original Code is State Machine Compiler (SMC).
// 
// The Initial Developer of the Original Code is Charles W. Rapp.
// Portions created by Charles W. Rapp are
// Copyright (C) 2000 - 2003 Charles W. Rapp.
// All Rights Reserved.
// 
// Contributor(s): 
//
// Name
//  TaskEventListener.java
//
// Description
//  Objects that will receive messages from the task controller
//  must implement this interface.
//
// RCS ID
// $Id: TaskEventListener.java,v 1.1 2005/05/28 12:49:21 cwrapp Exp $
//
// CHANGE LOG
// $Log: TaskEventListener.java,v $
// Revision 1.1  2005/05/28 12:49:21  cwrapp
// Added Ant examples 1 - 7.
//
// Revision 1.0  2004/05/31 13:19:38  charlesr
// Initial revision
//

package smc_ex5;

import java.util.Map;

public interface TaskEventListener
{
    public void handleEvent(String event, Map args);
}
