import React, { useState } from 'react';
import './App.css'
import { debugData } from "../utils/debugData";
import { fetchNui } from "../utils/fetchNui";
import { useNuiEvent } from '../hooks/useNuiEvent';
import FavoriteIcon from '@mui/icons-material/Favorite';
import HeartBrokenIcon from '@mui/icons-material/HeartBroken';
import VolunteerActivismIcon from '@mui/icons-material/VolunteerActivism';
import FavoriteBorderIcon from '@mui/icons-material/FavoriteBorder';
import { Button } from '@mui/material';

// This will set the NUI to visible if we are
// developing in browser
debugData([
  {
    action: 'setVisible',
    data: true,
  }
])

interface ReturnClientDataCompProps {
  data: any
}

const ReturnClientDataComp: React.FC<ReturnClientDataCompProps> = ({ data }) => (
  <>
    <h5>Returned Data:</h5>
    <pre>
      <code>
        {JSON.stringify(data, null)}
      </code>
    </pre>
  </>
)

interface ReturnData {
  x: number;
  y: number;
  z: number;
}

const App: React.FC = () => {
  const [clientData, setClientData] = useState<ReturnData | null>(null)
  const [userName, setUserName] = useState('')
  const [userStatus, setUserStatus] = useState('')
  const [userPartner, setUserPartner] = useState('')

  const handleGetClientData = () => {
    fetchNui<ReturnData>('getClientData').then(retData => {
      console.log('Got return data from client scripts:')
      console.dir(retData)
      setClientData(retData)
    }).catch(e => {
      console.error('Setting mock data due to error', e)
      setClientData({ x: 500, y: 300, z: 200 })
    })
  }

  useNuiEvent('sendFullname', (data) => {
    setUserName(data)
  })

  useNuiEvent('fullConjName', (data) => {
    setUserPartner(data)
  })
  
  useNuiEvent('sendStatus', (data) => {
    const mainData = JSON.parse(data)

    if (mainData.solteiro === 1) {
      setUserStatus('Solteiro(a)')
    }

    if (mainData.namorando === 1) {
      setUserStatus('Namorando')
    }
    
    if (mainData.noivando === 1) {
      setUserStatus('Noivando')
    }

    if (mainData.casado === 1) {
      setUserStatus('Casado(a)')
    }

    if (mainData.divorciado === 1) {
      setUserStatus('Solteiro(a)')
    }
  })

  const clickNamorar = () => {
    fetchNui('clickNamorar')
  }

  const clickNoivar = () => {
    fetchNui('clickNoivar')
  }

  const clickCasar = () => {
    fetchNui('clickCasar')
  }

  const clickSolteiro = () => {
    fetchNui('clickSolteiro')
  }

  return (
    <div className="nui-wrapper">
      <div className='popup-thing'>
          <div className='title-container'>
            <div>
            <FavoriteIcon fontSize='large' />
            <h1>Sistema de Relacionamentos</h1>
            <FavoriteIcon fontSize='large' />
            </div>
            <h3>Olá, {userName}!</h3>
          </div>
          <div className='status-container'>
            <span>Seu status atual é: {userStatus}</span>
            <p>Seu cônjuge atual é: {userPartner}</p>
          </div>
          <div className='button-container'>
            <Button onClick={clickNamorar}variant="contained" endIcon={<FavoriteIcon />}>
              Namorar
            </Button>
            <Button onClick={clickNoivar} variant="contained" endIcon={<VolunteerActivismIcon />}>
              Noivar
            </Button>
            <Button onClick={clickCasar} variant="contained" endIcon={<FavoriteBorderIcon />}>
              Casar
            </Button>
            <Button onClick={clickSolteiro} variant="contained" endIcon={<HeartBrokenIcon />}>
              Separar
            </Button>
          </div>
          {clientData && <ReturnClientDataComp data={clientData} />}
      </div>
    </div>
  );
}

export default App;
