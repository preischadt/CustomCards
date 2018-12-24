--Necrofake (TODO shuffle if banished, not summoned)
function c420000052.initial_effect(c)
	--first ss
	c:EnableReviveLimit()
	--materials
	aux.AddFusionProcCodeFun(c,28297833,c420000052.ffilter,1,true,true)
	--limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c420000052.splimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetValue(1)
	e2:SetCountLimit(1, 420000052)
	e2:SetCondition(c420000052.sprcon)
	e2:SetOperation(c420000052.sprop)
	c:RegisterEffect(e2)
	
	--change code
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetValue(28297833)
	c:RegisterEffect(e1)
end
function c420000052.ffilter(c)
	return c:IsRace(RACE_ZOMBIE) or c:IsAttribute(ATTRIBUTE_DARK)
end
function c420000052.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA)
end

function c420000052.spfilter1(c,tp)
	return c:IsCode(28297833) and c:IsAbleToRemoveAsCost() and c:IsCanBeFusionMaterial(nil,true)
		and Duel.IsExistingMatchingCard(c420000052.spfilter2,tp,LOCATION_GRAVE,0,1,c)
end
function c420000052.spfilter2(c)
	return (c:IsRace(RACE_ZOMBIE) or c:IsAttribute(ATTRIBUTE_DARK)) and c:IsCanBeFusionMaterial() and c:IsAbleToRemoveAsCost()
end
function c420000052.sprcon(e,c)
	if c==nil then return true end 
	local tp=c:GetControler()
	return Duel.GetLocationCountFromEx(tp,tp,c)>0
		and Duel.IsExistingMatchingCard(c420000052.spfilter1,tp,LOCATION_GRAVE,0,1,nil,tp)
end
function c420000052.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(48156348,2))
	local g1=Duel.SelectMatchingCard(tp,c420000052.spfilter1,tp,LOCATION_GRAVE,0,1,1,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(48156348,3))
	local g2=Duel.SelectMatchingCard(tp,c420000052.spfilter2,tp,LOCATION_GRAVE,0,1,1,g1:GetFirst())
	g1:Merge(g2)
	local tc=g1:GetFirst()
	while tc do
		--if not tc:IsFaceup() then Duel.ConfirmCards(1-tp,tc) end
		tc=g1:GetNext()
	end
	Duel.Remove(g1,POS_FACEUP,REASON_COST)
	
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1, 420000052+100)
	e1:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN)
	e1:SetCondition(c420000052.retcon)
	e1:SetOperation(c420000052.retop)
	e1:SetLabelObject(e:GetHandler())
	Duel.RegisterEffect(e1,tp)
end

function c420000052.retcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c420000052.retop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local g=Duel.GetFieldGroup(tp,LOCATION_REMOVED,LOCATION_REMOVED)
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
end







































