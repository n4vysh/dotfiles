@Sheet.after
def afterLoad(sheet):
    vd.queueCommand('resize-cols-max', sheet=sheet)
