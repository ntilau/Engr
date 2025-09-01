% determine material coefficients for present face
function [epsilon_r, mu_rInv] = faceMaterialProperties(project, faceCnt)

mtrId = project.link.face2mtr(faceCnt);
mtrPropId = project.geo.material(mtrId).mtrPropId;
epsilon_r = project.geo.materialProperty(mtrPropId).property.epsilon_relative.param;
mu_r = project.geo.materialProperty(mtrPropId).property.mu_relative.param;     
mu_rInv = 1/mu_r;
