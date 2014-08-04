# DO NOT EDIT.
# generated by smc (http://smc.sourceforge.net/)
# from file : AppClass.sm

import statemap


class AppClassState(statemap.State):

    def Entry(self, fsm):
        pass

    def Exit(self, fsm):
        pass

    def EOS(self, fsm):
        self.Default(fsm)

    def One(self, fsm):
        self.Default(fsm)

    def Unknown(self, fsm):
        self.Default(fsm)

    def Zero(self, fsm):
        self.Default(fsm)

    def Default(self, fsm):
        if fsm.getDebugFlag() == True:
            fsm.getDebugStream().write('TRANSITION   : Default\n')
        msg = "\n\tState: %s\n\tTransition: %s" % (
            fsm.getState().getName(), fsm.getTransition())
        raise statemap.TransitionUndefinedException, msg

class Map1_Default(AppClassState):

    def Unknown(self, fsm):
        if fsm.getDebugFlag() == True:
            fsm.getDebugStream().write("TRANSITION   : Map1.Default.Unknown()\n")

        loopbackFlag = fsm.getState().getName() == Map1.Error.getName()
        if loopbackFlag == False:
            fsm.getState().Exit(fsm)
        fsm.setState(Map1.Error)
        if loopbackFlag == False:
            fsm.getState().Entry(fsm)

class Map1_Start(Map1_Default):

    def EOS(self, fsm):
        ctxt = fsm.getOwner()
        if fsm.getDebugFlag() == True:
            fsm.getDebugStream().write("TRANSITION   : Map1.Start.EOS()\n")

        fsm.getState().Exit(fsm)
        fsm.clearState()
        try:
            ctxt.Acceptable()
        finally:
            fsm.setState(Map1.OK)
            fsm.getState().Entry(fsm)

    def One(self, fsm):
        if fsm.getDebugFlag() == True:
            fsm.getDebugStream().write("TRANSITION   : Map1.Start.One()\n")

        fsm.getState().Exit(fsm)
        fsm.setState(Map1.Ones)
        fsm.getState().Entry(fsm)

    def Zero(self, fsm):
        if fsm.getDebugFlag() == True:
            fsm.getDebugStream().write("TRANSITION   : Map1.Start.Zero()\n")

        fsm.getState().Exit(fsm)
        fsm.setState(Map1.Zeros)
        fsm.getState().Entry(fsm)

class Map1_Zeros(Map1_Default):

    def EOS(self, fsm):
        ctxt = fsm.getOwner()
        if fsm.getDebugFlag() == True:
            fsm.getDebugStream().write("TRANSITION   : Map1.Zeros.EOS()\n")

        fsm.getState().Exit(fsm)
        fsm.clearState()
        try:
            ctxt.Acceptable()
        finally:
            fsm.setState(Map1.OK)
            fsm.getState().Entry(fsm)

    def One(self, fsm):
        if fsm.getDebugFlag() == True:
            fsm.getDebugStream().write("TRANSITION   : Map1.Zeros.One()\n")

        fsm.getState().Exit(fsm)
        fsm.setState(Map1.Ones)
        fsm.getState().Entry(fsm)

    def Zero(self, fsm):
        if fsm.getDebugFlag() == True:
            fsm.getDebugStream().write("TRANSITION   : Map1.Zeros.Zero()\n")


class Map1_Ones(Map1_Default):

    def EOS(self, fsm):
        ctxt = fsm.getOwner()
        if fsm.getDebugFlag() == True:
            fsm.getDebugStream().write("TRANSITION   : Map1.Ones.EOS()\n")

        fsm.getState().Exit(fsm)
        fsm.clearState()
        try:
            ctxt.Acceptable()
        finally:
            fsm.setState(Map1.OK)
            fsm.getState().Entry(fsm)

    def One(self, fsm):
        if fsm.getDebugFlag() == True:
            fsm.getDebugStream().write("TRANSITION   : Map1.Ones.One()\n")


    def Zero(self, fsm):
        if fsm.getDebugFlag() == True:
            fsm.getDebugStream().write("TRANSITION   : Map1.Ones.Zero()\n")

        fsm.getState().Exit(fsm)
        fsm.setState(Map1.Error)
        fsm.getState().Entry(fsm)

class Map1_OK(Map1_Default):
    pass

class Map1_Error(Map1_Default):

    def EOS(self, fsm):
        ctxt = fsm.getOwner()
        if fsm.getDebugFlag() == True:
            fsm.getDebugStream().write("TRANSITION   : Map1.Error.EOS()\n")

        endState = fsm.getState()
        fsm.clearState()
        try:
            ctxt.Unacceptable()
        finally:
            fsm.setState(endState)

    def One(self, fsm):
        if fsm.getDebugFlag() == True:
            fsm.getDebugStream().write("TRANSITION   : Map1.Error.One()\n")


    def Zero(self, fsm):
        if fsm.getDebugFlag() == True:
            fsm.getDebugStream().write("TRANSITION   : Map1.Error.Zero()\n")


class Map1:

    Start = Map1_Start('Map1.Start', 0)
    Zeros = Map1_Zeros('Map1.Zeros', 1)
    Ones = Map1_Ones('Map1.Ones', 2)
    OK = Map1_OK('Map1.OK', 3)
    Error = Map1_Error('Map1.Error', 4)
    Default = Map1_Default('Map1.Default', -1)

class AppClass_sm(statemap.FSMContext):

    def __init__(self, owner):
        statemap.FSMContext.__init__(self)
        self._owner = owner
        self.setState(Map1.Start)
        Map1.Start.Entry(self)

    def EOS(self):
        self._transition = 'EOS'
        self.getState().EOS(self)
        self._transition = None

    def One(self):
        self._transition = 'One'
        self.getState().One(self)
        self._transition = None

    def Unknown(self):
        self._transition = 'Unknown'
        self.getState().Unknown(self)
        self._transition = None

    def Zero(self):
        self._transition = 'Zero'
        self.getState().Zero(self)
        self._transition = None

    def getState(self):
        if self._state == None:
            raise statemap.StateUndefinedException
        return self._state

    def getOwner(self):
        return self._owner

