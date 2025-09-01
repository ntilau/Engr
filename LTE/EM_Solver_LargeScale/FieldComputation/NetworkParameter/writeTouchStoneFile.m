function writeTouchStoneFile(Model, fname, networkMat)

M = sortNetworkParamsByPorts(networkMat);
dum = createDumStruct(M, Model.f, 50);

DUM2TouchStone(Model.path, fname, dum);

